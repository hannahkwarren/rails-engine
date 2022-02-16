# frozen_string_literals: false
# class ItemsController

class Api::V1::Revenue::ItemsController < ApplicationController
  def check_string(string)
    string.scan(/\D/).empty?
  end

  def by_quantity
    if params[:quantity].present?
      if check_string(params[:quantity]) == false || params[:quantity].length.zero?
        render json: { data: [], error: 'error' }, status: 400
      else
        items = Item.top_items_by_revenue(params[:quantity])
        render json: ItemRevenueSerializer.new(items), status: 200
      end
    else
      items = Item.top_items_by_revenue(10)
      render json: ItemRevenueSerializer.new(items), status: 200
    end
  end
end
