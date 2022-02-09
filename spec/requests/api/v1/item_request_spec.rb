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

  it "can edit an existing item" do 
    id = create(:item).id
      
    previous_description = Item.last.description
    item_params = { description: "Isn't it neat?" }
    headers = {"CONTENT_TYPE" => "application/json"}
    
      # We include this header to make sure that these params are passed as JSON rather than as plain text
    patch api_v1_item_path(id), headers: headers, params: JSON.generate({item: item_params})
    
    item = Item.find_by(id: id)
    
    expect(response).to be_successful
    expect(item.description).to_not eq(previous_description)
    expect(item.description).to eq("Isn't it neat?")
  end

  it "can destroy an item" do
    item = create(:item)
  
    expect{ delete api_v1_item_path(item.id) }.to change(Item, :count).by(-1)
    expect(response).to have_http_status(204)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can return one merchant at /api/v1/items/:id/merchant" do 
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
