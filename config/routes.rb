Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # resources :dashboard, as: "merchant_dashboard"
  resources :merchants do

    member { get "dashboard"}
  end
  # get "/merchants/:id/dashboard", to: "merchants#dashboard"
end
