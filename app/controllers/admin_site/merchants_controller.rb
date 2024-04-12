module AdminSite
  class MerchantsController < ApplicationController
    def index
      @merchants = Merchant.order(:id)
    end

    def show
      @merchant = Merchant.find(params[:id])
    end

    def edit
      @merchant = Merchant.find(params[:id])
    end

    def update
      @merchant = Merchant.find(params[:id])
      if params[:name].nil? || params[:name] == ""
        flash[:alert] = "You did not provide a valid name for this merchant."
        redirect_to("/admin/merchants/#{params[:id]}/edit")
      else
        @merchant.update(merchant_update_params)
        flash[:alert] = "You have successfully updated this merchant's information."
        redirect_to("/admin/merchants/#{params[:id]}")
      end
    end

    private

    def merchant_update_params
      params.permit(:name)
    end
  end
end
