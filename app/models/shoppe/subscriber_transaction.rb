module Shoppe
  class SubscriberTransaction < ActiveRecord::Base

    TYPES = %w(invoice prepay refund)

    belongs_to :subscriber
  end
end
