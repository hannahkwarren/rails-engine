class Api::V1::MerchantItemsController < ApplicationController
  def index
    find_merchant
    if !@merchant.nil?
      render json: ItemSerializer.new(Item.where(merchant_id: @merchant.id))
    end
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.to_s }, status: :not_found
  end
end
