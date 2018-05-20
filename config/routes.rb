Shoppe::Engine.routes.draw do
  resources :subscribers, only: [:index, :edit]

  resources :subscription_plans do
    resources :subscribers
    collection do
      get 'sync'
      patch 'stripe_account'
    end
  end

  resources :subscriber_gifts
end
