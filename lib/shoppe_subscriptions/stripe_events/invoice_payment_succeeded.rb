require 'shoppe_subscriptions/purchasing'
require 'errors/subscription_creation_error'

class InvoicePaymentSucceeded
  include Purchasing

  def call(event)
    ActiveRecord::Base.transaction do
      # Handle the incoming invoice succeeded webhook

      invoice = event.data.object

      # The subscription is left blank if the line item is an invoiceitem
      # First try to look up the subscription from supplied webhook data
      subscription_id = invoice.subscription || invoice.lines.data.first.try(:subscription)

      # We can no longer fall back on the customer subscriber association as this is now a has_many. That means if
      # a subscription Stripe ID's changes (for example if it is cancelled and reinstated), then we need to make
      # sure the Stripe ID in our Subscriber object is updated.
      # We now raise an error if we can't find the susbcriber so Stripe will retry, giving us a chance to get the
      # Stripe ID right in our DB.
      subscriber = Shoppe::Subscriber.unscoped.find_by(stripe_id: subscription_id)

      # Don't rely on Stripe customer as currently multiple purchases can result in multiple customers.
      # Therefore although we have a record of the last customer's stripe_id, the best plan is to ignore it.
      if subscriber.nil?
        customer = Shoppe::Customer.find_by stripe_id: invoice.customer
        # We have no choice but to take the first subscriber for this customer.
        # FIXME - the alternative is to reject this call. Should we do that?
        subscriber = customer.subscribers.try(:first)
      else
        customer = subscriber.customer
      end

      # Add amount to balance for relevant subscription
      if subscriber.present?
        total = Shoppe::ApiHandler.native_amount invoice.total
        subtotal = Shoppe::ApiHandler.native_amount invoice.subtotal
        tax = if invoice.tax.present?
                Shoppe::ApiHandler.native_amount invoice.tax
              else
                0
              end
        tax_percent = invoice.tax_percent.presence || 0
        # Subtotal is "Total of all subscriptions, invoice items, and prorations on the invoice before any discount is applied".
        # By using subtotal means we are taking into account any discount when deciding whether there are sufficient funs
        # to trigger a purchase below.
        subscriber.update_attributes!(balance: (subscriber.balance + subtotal))

        discount_code = invoice.discount.present? ? invoice.discount.coupon.id : nil

        # Record the transaction for accounting later
        subscriber.transactions.create(total: total,
                                       subtotal: subtotal,
                                       discount_code: discount_code,
                                       tax: tax,
                                       tax_percent: tax_percent,
                                       transaction_type: Shoppe::SubscriberTransaction::TYPES[0])

        # Only purchase where there is a plan, otherwise this is not a plan-style product and purchasing managed elsewhere
        if subscriber.subscription_plan.present?
          # Auto order the product if the balance now matches (or exceeds) product cost
          plan = subscriber.subscription_plan
          product = plan.product

          # We can only auto order if we correctly retrieve the product price, which fails if there are
          # variants but no default variant (as Shoppe returns the 0 priced parent product!)
          product = product.variants.first if product.has_variants? && product.default_variant.nil?

          # Include delivery charges (if any) when calculating price
          # Try to use any delivery_address if there is one. Next try to use the delivery address.
          # If there is none and there is more than 1 address use the last address (otherwise we
          # default delivery to biiling).
          delivery_address = subscriber.delivery_address || customer.addresses.delivery.first
          if delivery_address.nil?
            delivery_address = customer.addresses.last if customer.addresses.count > 1
          end

          product_price = plan.product_price(delivery_address.try(:country), delivery_address.try(:address4))

          if product_price.nil?
            Rails.logger.warn "Cannot find price in #{subscriber.currency} for product #{product.id}"
            raise SubscriptionCreationError.new("Cannot price in #{subscriber.currency} for product #{product.id}")
          end

          if subscriber.balance >= product_price
            purchase(customer, subscriber, invoice)
          end
        end
      else
        Rails.logger.warn "Cannot find subscriber with id #{subscription_id}"
        raise SubscriptionCreationError.new("Cannot find subscriber with ID #{subscription_id}")
      end
    end
  end
end
