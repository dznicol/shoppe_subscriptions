module Shoppe
  class SubscriberTransaction < Shoppe::ApplicationRecord

    TYPES = %w(invoice prepay refund)

    belongs_to :subscriber
  end
end
