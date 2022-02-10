class Api::V1::ItemsController < ApplicationController 

  def index 
    render json: ItemSerializer.new(Item.all)
  end

  def show 
    if find_merchant.class == Merchant
      render json: ItemSerializer.new(Item.find(params[:id]))
    else
      render json: {error: "Merchant Not Found"}, status: :not_found 
    end
  end
  
  def create 
    item_params.select { |x| Item.attribute_names.index(x)}

    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def update 
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
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

  def find_item 
    render json: ItemSerializer.new(Item.name_search(params[:query]).first)
  end

  private
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
