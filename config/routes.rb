Rails.application.routes.draw do
  root 'home#index'
  resources :promotions, only: [:index, :new, :create, :show, :edit, :update, :destroy]
end
