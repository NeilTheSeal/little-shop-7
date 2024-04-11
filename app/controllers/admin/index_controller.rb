module Admin
  class IndexController < ApplicationController
    def index
      @top_customers = Customer.top_customers
    end
  end
end
