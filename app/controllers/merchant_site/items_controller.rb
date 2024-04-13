module MerchantSite
  class ItemsController < ApplicationController
    def index
      @merchant = Merchant.find(params[:merchant_id])
    end

    def show
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:id])
    end

    def edit
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:id]) 
    end

    def update
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:id])
      @item.update(item_params)
      # require 'pry' ; binding.pry
      if params[:status]
        redirect_to merchant_items_path(@merchant)
      else
        flash[:notice] = "Item Updated"
        redirect_to merchant_item_path(@merchant, @item)
      end
    end

    private
    # Strong Params
    def item_params
      params.permit(:name, :description, :unit_price, :status)
    end
  end
end