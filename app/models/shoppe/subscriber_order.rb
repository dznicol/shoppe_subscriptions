module Shoppe
  class SubscriberOrder < ActiveRecord::Base
    belongs_to :order, class_name: 'Shoppe::Order'
    belongs_to :subscriber, class_name: 'Shoppe::Subscriber'
  end
end
