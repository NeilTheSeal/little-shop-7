module MerchantSite
  class DashboardController < ApplicationController
    def show
      @merchant = Merchant.find(params[:id])
    end
  end
end
