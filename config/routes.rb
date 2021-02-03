Rails.application.routes.draw do
  root 'home#index'
  resources :promotions, only: %i[index new create show edit update destroy] do
    post 'generate_coupons', on: :member
  end
end
