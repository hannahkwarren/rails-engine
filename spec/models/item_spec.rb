require 'rails_helper'

RSpec.describe Item, type: :model do 

  describe "relationships" do 
    it { should belong_to :merchant }
  end

  describe "class methods" do 
    it "searches by name, case-insensitive" do 
      item1 = create(:item, name: "nEmo A")
      item2 = create(:item, name: "finding nemo B")
      item3 = create(:item, name: "FindingNemo C")
      item4 = create(:item, name: "NemO D")
      item5 = create(:item, name: "nemo E")

      results = Item.name_search("NEMO")

      expect(results.count).to eq(5)
      expect(results).to eq([item3, item4, item2, item1, item5])
    end
  end
end
