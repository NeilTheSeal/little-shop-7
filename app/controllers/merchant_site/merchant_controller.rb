module MerchantSite
  class MerchantController < ApplicationController
    def index
      @all_merchants = Merchant.all
    end
  end
end
