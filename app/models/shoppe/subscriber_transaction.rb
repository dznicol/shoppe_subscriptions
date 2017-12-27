module Shoppe
  class SubscriberTransaction < ActiveRecord::Base

    TYPES = %w(invoice refund)

    belongs_to :subscriber
  end
end
