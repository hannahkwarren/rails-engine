# serializer for top by quantity sold query results
# frozen_string_literal: false

class MerchantNameQuantitySerializer
  include JSONAPI::Serializer

  attributes :name

  attributes :count do |object|
    object.count
  end
end
