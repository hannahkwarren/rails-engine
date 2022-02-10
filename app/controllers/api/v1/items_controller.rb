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

  def check_for_name_price(args={})
    params[:name] && (params[:min_price] || params[:max_price])
  end

  def valid_price_input(args={})
    args[:min_price].to_i > 0 || args[:max_price].to_i > 0
  end

  def valid_name_input(args)
    args != ""
  end

  def find_item 
    if check_for_name_price(params) 
      render json: { data: { error: "Invalid request"}}, status: 400
    elsif (params[:name])

      if valid_name_input(params[:name])
        items = Item.name_search(params[:name])
      
        if items == []
          render json: { data: {error: "No matching names found"} }, status: 200
        else
          render json: ItemSerializer.new(items.first)
        end
      else
        render json: { data: {error: "No matching names found"} }, status: 200
      end
    elsif params[:min_price] || params[:max_price]

      if valid_price_input(params) == true
        items = Item.price_search({min: params[:min_price], max: params[:max_price]})
      
        if items == []
          render json: { data: {error: "error"}}, status: :bad_request
        else
          render json: ItemSerializer.new(items.first)
        end
      else
        render json: { data: [], error: "error"}, status: :bad_request
      end
    else
      render json: { data: [], error: "error"}, status: :bad_request
    end
  end

  private
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
