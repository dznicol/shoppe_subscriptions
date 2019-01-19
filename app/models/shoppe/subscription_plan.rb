module Shoppe
  class SubscriptionPlan < Shoppe::ApplicationRecord
    include ApiHandler

    self.table_name = 'shoppe_subscription_plans'

    # Validations
    validates :name, presence: true
    validates :amount, presence: true
    validates :interval, presence: true

    belongs_to :product, class_name: 'Shoppe::Product'

    has_many :subscribers, class_name: 'Shoppe::Subscriber'

    attr_accessor :stripe_api_key
    attr_accessor :price

    def cancelled_subscribers
      subscribers.unscoped.where(subscription_plan_id: id).where.not(cancelled_at: nil)
    end

    # Price is plan amount plus additional shipping costs
    def price(delivery_country, state=nil)
      @price ||= calculate_price(delivery_country, state)
    end

    private

    def calculate_price(delivery_country, state=nil)
      prices = Shoppe::DeliveryServicePrice.joins(:delivery_service).where(shoppe_delivery_services: {active: true})
                   .where(currency: currency)
                   .order(:price).for_weight(product.default_variant.weight)
      prices = prices.select { |p| p.countries.empty? || p.country?(delivery_country) }
      if delivery_country.code2 == 'US' && state.present?
        prices = prices.select { |p| p.states.empty? || p.state?(state) }
      end
      prices.sort{ |x,y| (y.delivery_service.default? ? 1 : 0) <=> (x.delivery_service.default? ? 1 : 0) }
      prices.map(&:delivery_service).uniq

      amount + (prices.first.price / (product.price(currency) / amount))
    end

    def create_stripe_entity(api_key = nil)
      ::Stripe::Plan.create({
                                amount: stripe_amount(amount),
                                interval: interval,
                                interval_count: interval_count,
                                name: name,
                                currency: currency,
                                id: api_plan_id,
                                trial_period_days: trial_period_days
                            }, self.key(api_key))
    rescue ::Stripe::InvalidRequestError
      Rails.logger.info 'Stripe plan already exists!'
    end

    def delete_stripe_entity(api_key = nil)
      stripe_plan = retrieve_api_plan(api_plan_id, api_key)
      stripe_plan.delete
    end

    def update_stripe_entity(api_key = nil)
      if name_changed?
        stripe_plan = retrieve_api_plan(api_plan_id, api_key)
        stripe_plan.name = name
        stripe_plan.save
      end
    end
  end
end
