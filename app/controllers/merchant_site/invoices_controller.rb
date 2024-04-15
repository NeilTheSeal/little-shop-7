module MerchantSite
  class InvoicesController < ApplicationController
    def index
      @merchant = Merchant.find(params[:merchant_id])
      @invoices = @merchant.unique_invoices
      # require 'pry' ; binding.pry
    end

    def show
      @invoice = Invoice.find(params[:id])
      @customer = @invoice.customer
      
      # require 'pry' ; binding.pry
    end
  end
end
