FactoryBot.define do 
  factory :invoice_item do 
    item 
    invoice
    quantity { Faker::Number.within(range: 1..100) }
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits:2) }
  end
end
