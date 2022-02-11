class Api::V1::Items::SingleSearchController < ApplicationController 
  
  #business logic 

  def show
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

  #helpers

  def check_for_name_price(args)
    valid_name_input(args) ^ valid_price_input(args)
  end

  def valid_name_input(args)
    if args.has_key?(:name)
      true
    else
      false
    end
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

  private
  def item_params 
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end

end
