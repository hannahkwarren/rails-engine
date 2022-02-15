class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :update, :destroy]
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(@merchant)
  end

  def valid_name_input(args)
    args != ''
  end

  def find
    merchant = Merchant.name_search(params[:name]).first
    if valid_name_input(params[:name]) && !merchant.nil?
      render json: MerchantSerializer.new(merchant)
    elsif merchant.nil?
      render json: { data: { error: 'No matching names found' } }, status: 200
    else
      render json: { data: { error: 'Invalid request' } }, status: 400
    end
  end

  def find_all
    render json: MerchantSerializer.new(Merchant.name_search(params[:name]))
  end

  def most_items
    if params[:quantity].present?
      merchants = Merchant.top_merchants_by_quantity_sold(params[:quantity])
      render json: MerchantNameQuantitySerializer.new(merchants)
    else
      render json: { data: [], error: 'error' }, status: 400
    end
  end

  private
  def set_merchant
    @merchant = Merchant.find(params[:id])
  end
end
