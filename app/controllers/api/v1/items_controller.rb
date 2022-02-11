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

  def check_for_name_price(args)
    valid_name_input(args) ^ valid_price_input(args)
  end

  def valid_price_input(args)
    if args.has_key?(:min_price) || args.has_key?(:max_price)
      true 
    else
      false
    end
  end

  def check_positive_prices(args)
    if (args.has_key?(:min_price) && args[:min_price].to_i < 0) || (args.has_key?(:max_price) && args[:max_price].to_i < 0)
      false 
    else
      true
    end
  end

  def valid_name_input(args)
    if args.has_key?(:name)
      true
    else
      false
    end
  end

  def find_item 
    if check_for_name_price(params) == false
      render json: { data: { error: "Invalid request"}}, status: 400
    elsif params.has_key?(:name) 
      if params[:name] != ""
        items = Item.name_search(params[:name])
      
        if items == []
          render json: { data: {error: "No matching names found"} }, status: 200
        else
          render json: ItemSerializer.new(items.first)
        end
      else 
        render json: { data: { error: "No matching names found"}}, status: 200
      end
    else 
      if check_positive_prices(params) == false
        render json: { data: [], error: "error"}, status: :bad_request
      else 
        items = Item.price_search({min: params[:min_price], max: params[:max_price]})
      
        if items == []
          render json: { data: {error: "error"}}, status: :bad_request
        else
          render json: ItemSerializer.new(items.first)
        end
      end
    end
  end

  private
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
