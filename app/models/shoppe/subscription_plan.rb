module Shoppe
  class SubscriptionPlan < Shoppe::ApplicationRecord
    include ApiHandler

    self.table_name = 'shoppe_subscription_plans'

    # Validations
    validates :name, presence: true
    validates :amount, presence: true
    validates :interval, presence: true

    belongs_to :product, class_name: 'Shoppe::Product', optional: true

    has_many :subscribers, class_name: 'Shoppe::Subscriber'

    attr_accessor :stripe_api_key
    attr_accessor :price
    attr_accessor :product_price

    def cancelled_subscribers
      subscribers.unscoped.where(subscription_plan_id: id).where.not(cancelled_at: nil)
    end

    # Price is plan amount plus additional shipping costs
    def price(delivery_country, state=nil)
      @price ||= calculate_price(delivery_country, state)
    end

    # Product Price is the full price of product being purchased plus delivery costs
    def product_price(delivery_country, state=nil)
      @product_price ||= calculate_product_price(delivery_country, state)
    end

    def delivery_price_code(delivery_country, state=nil)
      delivery_price(delivery_country, state).try(:code)
    end

    private

    def calculate_price(delivery_country, state=nil)
      amount + ((delivery_price(delivery_country, state).try(:price) || 0) / (product.price(currency) / amount))
    end

    def calculate_product_price(delivery_country, state=nil)
      product.price(currency) + (delivery_price(delivery_country, state).try(:price) || 0)
    end

    def delivery_price(delivery_country, state=nil)
      variant = product.default_variant || product.variants.first || product
      delivery_prices = Shoppe::DeliveryServicePrice.joins(:delivery_service).where(shoppe_delivery_services: {active: true})
                            .where(currency: currency)
                            .order(:price).for_weight(variant.weight)
      delivery_prices = delivery_prices.select { |p| p.countries.empty? || p.country?(delivery_country) }
      if delivery_country.code2 == 'US' && state.present?
        delivery_prices = delivery_prices.select { |p| p.states.empty? || p.state?(state) }
      end
      delivery_prices.sort{ |x,y| (y.delivery_service.default? ? 1 : 0) <=> (x.delivery_service.default? ? 1 : 0) }
      delivery_prices.map(&:delivery_service).uniq
      delivery_prices.first
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
      stripe_plan = retrieve_subscription_plan(api_plan_id, api_key)
      stripe_plan.delete
    end

    def update_stripe_entity(api_key = nil)
      if saved_change_to_name?
        stripe_plan = retrieve_subscription_plan(api_plan_id, api_key)
        stripe_product = retrieve_subscription_product(stripe_plan.product, api_key)
        stripe_product.name = name
        stripe_product.save
      end
    end
  end
end
