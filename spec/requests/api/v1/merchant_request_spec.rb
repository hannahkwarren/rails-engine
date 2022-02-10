require 'rails_helper'

RSpec.describe "The merchants API" do

  context "happy path, RESTful" do
    it "sends a list of merchants" do 
      create_list(:merchant, 5)

      get api_v1_merchants_path

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)
      merchants_data = merchants[:data].map {|m| m[:attributes]}

      expect(merchants_data.count).to eq(5)

      merchants_data.each do |merchant|
        expect(merchant).to have_key(:name)
        expect(merchant[:name]).to be_a(String)
      end
    end

    it "can get one merchant by its id" do 
      id = create(:merchant).id 

      get api_v1_merchant_path(id)

      merchant = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]
      
      expect(response).to be_successful
      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end

    it "can get all of one merchant's items" do 
      id = create(:merchant).id 

      create_list(:item, 5, merchant_id: id)

      get api_v1_merchant_items_path(id)

      items = JSON.parse(response.body, symbolize_names: true )
    
      merchant_items_attributes = items[:data].map {|i| i[:attributes]}
      merchant_items_relationships = items[:data].map {|i| i[:relationships]}
      
      expect(response).to be_successful 
      expect(merchant_items_attributes.count).to eq(5)

      merchant_items_attributes.each do |item|
        expect(item).to have_key(:name)
        expect(item[:name]).to be_a(String)

        expect(item).to have_key(:description)
        expect(item[:description]).to be_a(String)

        expect(item).to have_key(:unit_price)
        expect(item[:unit_price]).to be_a(Float)

        expect(item[:merchant_id]).to be_an(Integer)
        expect(item[:merchant_id]).to eq(id)
      end
    end
  end

  context "sad path, RESTful: when merchant record doesn't exist" do
    it "returns status code 404" do 
      id = 1313487235964719847

      get api_v1_merchant_items_path(id)
    
      expect(response).to have_http_status(404)
      expect(response.body).to match("{\"error\":\"Couldn't find Merchant with 'id'=1313487235964719847\"}")
    end
  end

  context "happy path, non-RESTful" do 
    it "searches by name" do
      merch1 = create(:merchant, name: "Little Big Shoppe of Horrors")
      merch2 = create(:merchant, name: "This Shop Blinks")
      merch3 = create(:merchant, name: "Easily Amused Studio")
      merch4 = create(:merchant, name: "the big easy shop")
      merch5 = create(:merchant, name: "allDolls")

      get "/api/v1/merchants/find?name=Big"

      expect(response).to be_successful 
      results = JSON.parse(response.body, symbolize_names: true )[:data]
      expect(results.count).to eq(2)
    end
  end


end
