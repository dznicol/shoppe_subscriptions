Shoppe::Engine.routes.draw do
  resources :subscribers, only: [:index, :edit]

  resources :subscription_plans do
    resources :subscribers, shallow: true
    collection do
      get 'sync'
      patch 'stripe_account'
    end
  end

  resources :subscriber_gifts
  resources :subscriber_transactions
end
