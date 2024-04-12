module MerchantSite
  class ItemsController < ApplicationController
    def index
      # require 'pry' ; binding.pry
      @merchant = Merchant.find(params[:merchant_id])
    end
  end
end
