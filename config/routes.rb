Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions, only: %i[index new create show edit update destroy] do
    post 'generate_coupons', on: :member
  end

  resources :coupons, only: [] do
    post 'inactivate', on: :member
  end
end
