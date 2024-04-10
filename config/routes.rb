Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "welcome#index"

  # resources :dashboard, as: "merchant_dashboard"

  resources :merchants do
    member { get "dashboard"}
    resources :items, controller: "merchant_items", only: [:index]
    resources :invoices, controller: "merchant_invoices", only: [:index]
  end

  # get "/merchants/:id/dashboard", to: "merchants#dashboard"
end
