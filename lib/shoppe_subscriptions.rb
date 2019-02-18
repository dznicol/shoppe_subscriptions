require 'shoppe_subscriptions/engine'
require 'stripe_event'
require 'shoppe_subscriptions/stripe_events/invoice_payment_succeeded'
require 'shoppe_subscriptions/stripe_events/charge_refunded'

module ShoppeSubscriptions
  class << self
    def setup
      StripeEvent.configure do |events|
        events.subscribe 'invoice.payment_succeeded', InvoicePaymentSucceeded.new
        events.subscribe 'charge.refunded', ChargeRefunded.new

        require 'shoppe_subscriptions/customer_extensions'
      end

    end
  end
end
