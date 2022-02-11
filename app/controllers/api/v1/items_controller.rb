class Api::V1::ItemsController < ApplicationController 

  def index 
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    if find_merchant.class == Merchant
      render json: ItemSerializer.new(Item.find(params[:id]))
    end
  end
  
  def create 
    item_params.select { |x| Item.attribute_names.index(x)}

    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def valid_merchant_id?(item_params)
    if !item_params.has_key?(:merchant_id)
      true 
    else
      false if Merchant.where(id: item_params[:merchant_id]) == [] 
    end
  end

  def valid_id?(params)
    true if Float(params[:id]) rescue false
  end

  def update 
    if valid_merchant_id?(item_params) == false 
      render json: { data: {error: "Bad Request"}}, status: 400
    elsif valid_id?(params) == false
      render json: { data: {error: "Not Found"}}, status: 404
    else
      render json: ItemSerializer.new(Item.update(params[:id], item_params))
    end
  end

  def destroy
    Item.destroy(params[:id])
  end

  def items_merchant 
    Item.find(params[:id]).merchant
  end

  def render_merchant 
    render json: MerchantSerializer.new(items_merchant)
  end

  def find_merchant 
    Merchant.find(items_merchant.id)
  end

  def find_items 
    render json: ItemSerializer.new(Item.name_search(params[:name]))
  end

  private
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
