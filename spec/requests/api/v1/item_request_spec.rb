require 'rails_helper'

RSpec.describe "The Items API" do 
  
  context "RESTful endpoints" do 
    it "can get all items (regardless of merchant)" do 
      create_list(:item, 5)

      get "/api/v1/items"

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)
      
      items_data = items[:data].map {|m| m[:attributes]}

      expect(items_data.count).to eq(5)

      items_data.each do |item|
        expect(item).to have_key(:name)
        expect(item[:name]).to be_a(String)
        
        expect(item).to have_key(:description)
        expect(item[:description]).to be_a(String)

        expect(item).to have_key(:unit_price)
        expect(item[:unit_price]).to be_a(Float)

        expect(item).to have_key(:merchant_id)
        expect(item[:merchant_id]).to be_an(Integer)
      end
    end
    
    it "can get one item" do 
      id = create(:item).id 

      get api_v1_item_path(id)

      item_data = JSON.parse(response.body, symbolize_names: true)[:data]
      item_attributes = item_data[:attributes]
      
      expect(response).to be_successful
      
      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_a(String)
      expect(item_data[:id]).to eq(id.to_s)

      expect(item_attributes).to have_key(:name)
      expect(item_attributes[:name]).to be_a(String)

      expect(item_attributes).to have_key(:description)
      expect(item_attributes[:description]).to be_a(String)

      expect(item_attributes).to have_key(:unit_price)
      expect(item_attributes[:unit_price]).to be_a(Float)

      expect(item_attributes).to have_key(:merchant_id)
      expect(item_attributes[:merchant_id]).to be_an(Integer)
    end

    it "can create an item, ignores superfluous keys + values" do 
      id = create(:merchant).id 
      item_params = ({
        name: 'Thingamabob',
        description: 'A fork.',
        unit_price: 9.99,
        merchant_id: id, 
        nonsense: 'stuff'
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
      created_item = Item.last

      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it "can edit an existing item" do 
      id = create(:item).id
        
      previous_description = Item.last.description
      item_params = { description: "Isn't it neat?" }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch api_v1_item_path(id), headers: headers, params: JSON.generate({item: item_params})
      
      item = Item.find_by(id: id)
      
      expect(response).to be_successful
      expect(item.description).to_not eq(previous_description)
      expect(item.description).to eq("Isn't it neat?")
    end

    it "sad path: can't edit an existing item if merchant id provided is bad" do 
      item = create(:item)
      id = item.id
        
      previous_description = Item.last.description
      item_params = { description: "Isn't it neat?", merchant_id: 999999999999999999 }
      headers = {"CONTENT_TYPE" => "application/json"}

      patch api_v1_item_path(id), headers: headers, params: JSON.generate({item: item_params})
      # binding.pry
      expect(response).to have_http_status(400)
      expect(item.description).to eq(previous_description)
    end

    it "sad path: item id is a string" do 
      item_params = { description: "Isn't it neat?"}
      headers = {"CONTENT_TYPE" => "application/json"}
      patch api_v1_item_path("stringy"), headers: headers, params: JSON.generate({item: item_params})
      # binding.pry
      expect(response).to have_http_status(404)
    end

    it "can destroy an item" do
      item = create(:item)
    
      expect{ delete api_v1_item_path(item.id) }.to change(Item, :count).by(-1)
      expect(response).to have_http_status(204)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  
    it "return one merchant at /api/v1/items/:id/merchant" do 
      m_id = create(:merchant).id
      item = create(:item, merchant_id: m_id)
      
      get "/api/v1/items/#{item.id}/merchant"
      
      merchant_data = JSON.parse(response.body, symbolize_names: true)[:data]
      merchant_attributes = merchant_data[:attributes]
      
      expect(response).to be_successful
      expect(merchant_data.count).to eq(3)
      expect(merchant_attributes.count).to eq(1)
      expect(merchant_attributes).to have_key(:name)
      expect(merchant_attributes[:name]).to be_a(String)
    end
  end

  context "non-RESTful search" do 
    it "happy path: search for an item by name" do 
      item1 = create(:item, name: "nEmo A")
      item2 = create(:item, name: "nemo B")
      item3 = create(:item, name: "Nemo C")
      item4 = create(:item, name: "NemO D")
      item5 = create(:item, name: "nemo E")

      get "/api/v1/items/find?name=Nemo"
      
      expect(response).to be_successful
      
      item = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(item).to be_a(Hash)
      expect(item[:attributes][:name]).to eq("NemO D")
    end

    it "sad path: search for a fragment, no results" do 
      item1 = create(:item, name: "nEmo A")
      item2 = create(:item, name: "nemo B")
      item3 = create(:item, name: "Nemo C")
      item4 = create(:item, name: "NemO D")
      item5 = create(:item, name: "nemo E")

      get "/api/v1/items/find?name="
      expect(response).to have_http_status(200)
      r = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(r[:error]).to eq("No matching names found")
    end

    it "happy path: can search for many items results" do 
      item1 = create(:item, name: "nEmo A")
      item2 = create(:item, name: "nemo B")
      item3 = create(:item, name: "Nemo C")
      item4 = create(:item, name: "NemO D")
      item5 = create(:item, name: "nemo E")

      get "/api/v1/items/find_all?name=Nemo"
      
      expect(response).to be_successful
      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to be_an(Array)
      expect(data.length).to eq(5)
    end

    it "sad path: can't search for name and price query at once" do 
      item1 = create(:item, name: "nEmo A")
      item2 = create(:item, name: "nemo B")
      item3 = create(:item, name: "Nemo C")
      item4 = create(:item, name: "NemO D")
      item5 = create(:item, name: "nemo E")

      get '/api/v1/items/find?name=harry&min_price=10'

      r = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to have_http_status(400)
      expect(r[:error]).to eq("Invalid request")
    end

    it "sad path: no search results" do 
      item1 = create(:item, name: "nEmo A")
      item2 = create(:item, name: "nemo B")
      item3 = create(:item, name: "Nemo C")
      item4 = create(:item, name: "NemO D")
      item5 = create(:item, name: "nemo E")

      get '/api/v1/items/find?name=NOBODYKNOWSMEATALL'
      expect(response).to be_successful
      r = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response).to have_http_status(200)
      expect(r[:error]).to eq("No matching names found")
    end

    it "happy path: can get first item over a minimum unit_price" do 
      item1 = create(:item, unit_price: 0.99)
      item2 = create(:item, unit_price: 8.50)
      item3 = create(:item, name: "C", unit_price: 10.00)
      item4 = create(:item, name: "B", unit_price: 100.00)
      item5 = create(:item, name: "A", unit_price: 300.99)

      get "/api/v1/items/find?min_price=10"

      expect(response).to be_successful 
      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to be_a(Hash)
      expect(data[:attributes][:name]).to eq(item5.name)
    end

    it "happy path: can get first item under a maximum unit_price" do 
      item1 = create(:item, unit_price: 0.99)
      item2 = create(:item, unit_price: 8.50)
      item3 = create(:item, unit_price: 10.00)
      item4 = create(:item, unit_price: 100.00)
      item5 = create(:item, unit_price: 300.99)

      get "/api/v1/items/find?max_price=10"

      expect(response).to be_successful 
      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to be_a(Hash)
      expect(data[:attributes][:name]).to eq(item3.name)
    end

    it "happy path: can get items over a minimum AND under a maximum unit_price" do 
      item1 = create(:item, unit_price: 0.99)
      item2 = create(:item, unit_price: 8.50)
      item3 = create(:item, unit_price: 10.00)
      item4 = create(:item, unit_price: 50.00)
      item5 = create(:item, unit_price: 300.99)

      get "/api/v1/items/find?min_price=8&max_price=50"

      expect(response).to be_successful 
      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to be_a(Hash)
      expect(data[:attributes][:name]).to eq(item2.name)
    end
  end

end
