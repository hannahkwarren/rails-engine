# serializer for returning a given merchant's revenue all-time
# frozen_string_literal: false

class MerchantRevenueSerializer
  include JSONAPI::Serializer

  attributes :revenue do |object|
    object.revenue
  end
end
