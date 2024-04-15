Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "welcome#index"

  resources(
    :merchant, controller: "merchant_site/merchant", only: %i[index]
  ) do
    resources(
      :dashboard,
      controller: "merchant_site/dashboard",
      only: %i[index]
    )
    resources(
      :items,
      controller: "merchant_site/items",
      only: %i[index show edit update]
    )
    resources(
      :invoices,
      controller: "merchant_site/invoices",
      only: %i[index show]
    )
  end

  resources(
    :admin,
    controller: "admin_site/admin",
    only: %i[index]
  )

  namespace :admin_site, path: "/admin" do
    resources(
      :merchants,
      controller: "merchants",
      only: %i[index show edit update create new]
    )

    resources(
      :invoices,
      controller: "invoices",
      only: %i[index show]
    )
  end
end
