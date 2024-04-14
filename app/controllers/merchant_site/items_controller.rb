module MerchantSite
  class ItemsController < ApplicationController
    def index
      # require 'pry' ; binding.pry
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    end

    def show
      @item = Item.find(params[:id])
    end

    def edit
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:id])
    end

    def update
      @item = Item.find(params[:id])
      @item.update(item_params)
      if params[:status]
        redirect_to merchant_items_path(params[:merchant_id])
      else
        flash[:notice] = "Item Updated"
        redirect_to merchant_item_path(params[:merchant_id], @item)
      end
    end

    private

    def item_params
      params.permit(:name, :description, :unit_price, :status)
    end
  end
end
