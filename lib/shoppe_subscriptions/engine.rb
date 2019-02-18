require 'shoppe/navigation_manager'

module ShoppeSubscriptions
  class Engine < ::Rails::Engine
    isolate_namespace ShoppeSubscriptions

    initializer 'shoppe_subscriptions.initializer' do
      ShoppeSubscriptions.setup
    end

    # Load default navigation
    config.after_initialize do
      require 'shoppe_subscriptions/subscription_navigation'
      # require 'shoppe_subscriptions/customer_extensions'
    end
  end
end
