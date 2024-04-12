module MerchantSite
  class MerchantController < ApplicationController
    def show
      @merchant = Merchant.find(params[:id])
    end
  end
end
