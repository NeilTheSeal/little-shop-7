module AdminSite
  class AdminController < ApplicationController
    def index
      @top_customers = Customer.top_customers
      @unshipped_invoices = Invoice.unshipped_invoices
    end
  end
end
