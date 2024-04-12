Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "welcome#index"

  resources(
    :merchant,
    controller: "merchant_site/merchant",
    only: %i[index show]
  ) do
    resources :items, controller: "merchant_site/items", only: [:index]
    resources :invoices, controller: "merchant_site/invoices", only: [:index]
  end

  resources(
    :admin,
    controller: "admin_site/admin",
    only: %i[index]
  )

  namespace :admin_site, path: "/admin" do
    resources :merchants, controller: "merchants", only: [:index, :show]
    resources :invoices, controller: "invoices", only: %i[index show]
  end
end
