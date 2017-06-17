require 'shoppe_subscriptions/engine'
require 'stripe_event'
require 'shoppe_subscriptions/stripe_events/invoice_payment_succeeded'

module ShoppeSubscriptions
  class << self
    def setup
      StripeEvent.configure do |events|
        events.subscribe 'invoice.payment_succeeded', InvoicePaymentSucceeded.new
      end

    end
  end
end
