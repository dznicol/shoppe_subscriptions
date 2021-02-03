class AddPriceIdToSubscriptionPlans < ActiveRecord::Migration[5.2]
    def change
        add_column :shoppe_subscription_plans, :stripe_additional_price, :string
    end
  end