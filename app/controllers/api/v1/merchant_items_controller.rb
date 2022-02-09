class Api::V1::MerchantItemsController < ApplicationController 

  def index 
    render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id])) or not_found
  end
end