class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show, :update, :destroy]
  # rescue_from ActiveRecord::RecordNotFound, :with => render_404

  def index 
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show 
    
    # # json_response(MerchantSerializer.new(@merchant))
    # if @merchant.class == Merchant
      json_response(MerchantSerializer.new(@merchant))
      # rescue_from ActiveRecord::RecordNotFound, :with => render_404

    # else
    #   render json: ErrorMerchantSerializer.new(@merchant).serialized_json
    #   # rescue_from ActiveRecord::
    # end
  end

  def render_404 
    render :status => 404, :text => "not found"
  end

  private
  def set_merchant 
    @merchant = Merchant.find(params[:id]) or not_found
  end

end
