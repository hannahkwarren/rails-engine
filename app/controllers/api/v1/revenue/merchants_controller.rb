class Api::V1::Revenue::MerchantsController < ApplicationController
  def revenue
    if params[:id].present?
      merch = Merchant.find(params[:id])
      unless merch.nil?
        rev = Merchant.revenue(params[:id])
        render json: MerchantRevenueSerializer.new(rev[0])
      end
    else
      render json: { data: [], error: 'error' }, status: 404
    end
  end
end
