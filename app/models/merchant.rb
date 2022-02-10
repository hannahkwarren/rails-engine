class Merchant < ApplicationRecord
  has_many :items
  include SearchModule
end
