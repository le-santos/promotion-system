Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions, only: %i[index new create show edit update destroy] do
    member do
      post 'generate_coupons'
      post 'approve'
    end
  end

  resources :coupons, only: [] do
    post 'inactivate', on: :member
  end

  namespace 'api', defaults: { format: :json } do
    namespace 'v1' do
      resources :coupons, only: [:show]
    end
  end
end
