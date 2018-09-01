module Shoppe
  class SubscriberOrder < Shoppe::ApplicationRecord
    belongs_to :order, class_name: 'Shoppe::Order'
    belongs_to :subscriber, class_name: 'Shoppe::Subscriber'
  end
end
