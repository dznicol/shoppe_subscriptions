module Shoppe
  class SubscriberTransaction < Shoppe::ApplicationRecord

    TYPES = %w(invoice prepay refund)

    belongs_to :subscriber

    belongs_to :retailer, optional: :true
  end
end
