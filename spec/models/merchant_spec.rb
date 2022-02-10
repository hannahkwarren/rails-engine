require 'rails_helper'

RSpec.describe Merchant, type: :model do 

  describe "relationships" do 
    it { should have_many(:items) }
  end

  describe "class methods" do 
    it "searches by name, case-insensitive" do 
      merch1 = create(:merchant, name: "Little Shoppe of Horrors")
      merch2 = create(:merchant, name: "This Shop Blinks")
      merch3 = create(:merchant, name: "Momyer Pottery")
      merch4 = create(:merchant, name: "allthesethingsarebelongtous")
      merch5 = create(:merchant, name: "All Dolls")

      results = Merchant.name_search("all")

      expect(results.count).to eq(2)
      expect(results).to eq([merch5, merch4])

      results = Merchant.name_search("Shop")

      expect(results.count(2))
      expect(results).to eq([merch1, merch2])
    end
  end

end
