Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "welcome#index"

  # resources :dashboard, as: "merchant_dashboard"
  resources :merchants do
    member { get "dashboard"}
    resources :items, controller: "merchant_items", only: [:index]
    resources :invoices, controller: "merchant_invoices", only: [:index]
  end

  scope module: 'admin' do
    resources :admin, controller: "index", only: [:index]
  end

  namespace :admin do
    resources :merchants, controller: "merchants", only: [:index]
    resources :invoices, controller: "invoices", only: [:index, :show]
  end
end
