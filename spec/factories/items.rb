FactoryBot.define do 
  factory :item do 
    merchant 
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    # unit_price { Money.new(rand(0..100)}
    unit_price { Faker::Number.decimal(l_digits: 3, r_digits:2) }
  end
end
