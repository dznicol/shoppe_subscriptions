module Shoppe
  class SubscriberProductBlock < Shoppe::ApplicationRecord
    belongs_to :subscriber
    belongs_to :product
  end
end
