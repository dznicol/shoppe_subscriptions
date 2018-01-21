module Shoppe
  class Gift < ActiveRecord::Base
    belongs_to :product, class_name: 'Shoppe::Product'
    belongs_to :subscriber, class_name: 'Shoppe::Subscriber'

    scope :unclaimed, -> { where(claimed: false) }

    def subscriber
      Shoppe::Subscriber.unscoped { super }
    end
  end
end
