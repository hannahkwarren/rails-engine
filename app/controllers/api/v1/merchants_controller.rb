class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :update, :destroy]
  
  def index 
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show 
    render json: MerchantSerializer.new(@merchant)
  end

  def find 
    render json: MerchantSerializer.new(Merchant.name_search(params[:name]).first)
  end

  def find_all 
    render json: MerchantSerializer.new(Merchant.name_search(params[:name]))
  end

  private
  def set_merchant 
    @merchant = Merchant.find(params[:id])
  end

end
