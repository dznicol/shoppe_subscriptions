module Shoppe
  class Subscriber < ActiveRecord::Base

    PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/

    include ApiHandler

    belongs_to :subscription_plan, class_name: 'Shoppe::SubscriptionPlan'

    belongs_to :customer, class_name: 'Shoppe::Customer'

    has_many :transactions, class_name: 'Shoppe::SubscriberTransaction'

    has_many :subscriber_gifts, class_name: 'SubscriberGift', inverse_of: :subscriber

    has_many :subscriber_orders, class_name: 'Shoppe::SubscriberOrder'
    has_many :orders, through: :subscriber_orders

    belongs_to :delivery_address, class_name: 'Shoppe::Address'

    default_scope { where(cancelled_at: nil) }
    scope :cancelled, -> { where.not(cancelled_at: nil) }

    attr_accessor :stripe_api_key

    validates :recipient_phone, allow_blank: true, format: { with: PHONE_REGEX }

    def full_name
      recipient_name.presence || customer.full_name
    end

    def full_details
      recipient_name.blank? ? customer.full_name : "#{customer.full_name} (#{recipient_name})"
    end

    private

    def create_stripe_entity(_api_key = nil)
      Rails.logger.warn 'Creation of Subscribers from Shoppe interface is not currently supported'
    end

    def delete_stripe_entity(api_key = nil)
      subscription = retrieve_subscription(stripe_id, api_key)
      subscription.delete
    end

    def update_stripe_entity(api_key = nil)
      if cancelled_at_changed? and cancelled_at.present?
        delete_stripe_entity(api_key)
      end
    end
  end
end
