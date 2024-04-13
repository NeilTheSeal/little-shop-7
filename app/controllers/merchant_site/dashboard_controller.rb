module MerchantSite
  class DashboardController < ApplicationController
    def index
      @all_merchants = Merchant.all
    end

    def show
      @merchant = Merchant.find(params[:id])
    end
  end
end
