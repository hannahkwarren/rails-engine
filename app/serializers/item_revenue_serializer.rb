# class ItemRevenueSerializer
# frozen_string_literal: false

class ItemRevenueSerializer
  include JSONAPI::Serializer

  attributes :name
  attributes :unit_price
  attributes :description
  attributes :merchant_id

  attributes :revenue do |object|
    object.revenue
  end
end
