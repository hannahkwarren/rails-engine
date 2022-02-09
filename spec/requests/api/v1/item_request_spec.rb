require 'rails_helper'

RSpec.describe "The Items API" do 
  
  it "can get all items (regardless of merchant)" do 
    create_list(:item, 5)

    get api_v1_items_path

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

  it "can create an item" do 
    id = create(:merchant).id 
    item_params = ({
      name: 'Thingamabob',
      description: 'A fork.',
      unit_price: 9.99,
      merchant_id: id
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    # We include this header to make sure that these params are passed as JSON rather than as plain text
    post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)
    # binding.pry
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end




end