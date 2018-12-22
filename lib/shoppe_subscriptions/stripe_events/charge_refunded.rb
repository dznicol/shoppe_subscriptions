require 'shoppe_subscriptions/purchasing'

class ChargeRefunded
  def call(event)
    ActiveRecord::Base.transaction do
      # Handle the incoming invoice succeeded webhook
      charge = event.data.object

      refunds = charge.refunds
      refund_total = refunds.data.sum { |refund| Shoppe::ApiHandler.native_amount(refund.amount) }

      if charge.invoice.present?
        invoice = Stripe::Invoice.retrieve(charge.invoice, Shoppe::Stripe.api_key)

        subscriber = Shoppe::Subscriber.find_by(stripe_id: invoice.subscription)

        if subscriber.present?
          subscriber.transactions.create(total: refund_total, transaction_type: 'refund')
          subscriber.balance -= total
          subscriber.save
        end
      elsif charge.customer.present?
        shoppe_customer = Shoppe::Customer.find_by(stripe_id: charge.customer)

        # Find the first prepay for this subscriber
        if shoppe_customer.present?
          prepay_subscriber = shoppe_customer.subscribers.find_by(subscription_plan: nil) || shoppe_customer.subscribers.first

          if prepay_subscriber.present?
            prepay_subscriber.transactions.create(total: refund_total, transaction_type: 'refund')
            prepay_subscriber.save
          end
        end
      end
    end
  end
end
