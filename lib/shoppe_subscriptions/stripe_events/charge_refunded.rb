require 'shoppe_subscriptions/purchasing'

class ChargeRefunded
  def call(event)
    ActiveRecord::Base.transaction do
      # Handle the incoming invoice succeeded webhook

      charge = event.data.object

      if charge.invoice.present?
        invoice = Stripe::Invoice.retrieve(charge.invoice, Shoppe::Stripe.api_key)

        subscriber = Shoppe::Subscriber.find_by(stripe_id: invoice.subscription)

        if subscriber.present?
          # Record the transaction for accounting later
          refunds = charge.refunds
          total = refunds.data.sum { |refund| Shoppe::ApiHandler.native_amount(refund.amount) }

          subscriber.transactions.create(total: total,
                                         transaction_type: Shoppe::SubscriberTransaction::TYPES[1])
          subscriber.balance -= total
          subscriber.save
        end
      end
    end
  end
end
