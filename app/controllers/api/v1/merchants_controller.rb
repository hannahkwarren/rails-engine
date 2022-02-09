class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :update, :destroy]
  
  def index 
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show 
    render json: MerchantSerializer.new(@merchant)
  end

  private
  def set_merchant 
    @merchant = Merchant.find(params[:id])
  end

end
