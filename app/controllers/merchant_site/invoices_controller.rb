module MerchantSite
  class InvoicesController < ApplicationController
    def index
    end

    def show
      @invoice = Invoice.find(:invoice_id)
    end
  end
end
