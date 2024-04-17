module AdminSite
  class MerchantsController < ApplicationController
    def index
      @merchants = Merchant.order(:id)
      @top_merchants = Merchant.top_five_merchants
    end

    def show
      @merchant = Merchant.find(params[:id])
    end

    def edit
      @merchant = Merchant.find(params[:id])
    end

    def update
      @merchant = Merchant.find(params[:id])
      if params[:status] != @merchant.status
        @merchant.update(merchant_update_params)
        redirect_to("/admin/merchants")
      elsif params[:name].nil? || params[:name] == ""
        flash[:alert] = "You did not provide a valid name for this merchant."
        redirect_to("/admin/merchants/#{params[:id]}/edit")
      else
        @merchant.update(merchant_update_params)
        flash[:alert] =
          "You have successfully updated this merchant's information."
        redirect_to("/admin/merchants/#{params[:id]}")
      end
    end

    def new
    end

    def create
      merchant = Merchant.new(merchant_new_params)
      if merchant.save
        redirect_to("/admin/merchants")
      else
        flash[:alert] = "Error: #{merchant.errors.full_messages}"
        redirect_to("/admin/merchants/new")
      end
    end

    private

    def merchant_new_params
      params.permit(:name, :status)
    end

    def merchant_update_params
      params.permit(:name, :status)
    end
  end
end
