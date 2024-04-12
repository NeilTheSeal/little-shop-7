module AdminSite
  class MerchantsController < ApplicationController
    def index
      @merchants = Merchant.all
    end
  end
end
