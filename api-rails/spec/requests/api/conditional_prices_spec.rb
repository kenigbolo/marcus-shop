require 'rails_helper'

RSpec.describe 'ConditionalPrices API', type: :request do
  let(:headers) { { 'HTTP_X_ADMIN_ID' => 'admin-123' } }

  describe 'GET /api/part_options/:part_option_id/conditional_prices' do
    it 'returns all conditional prices for the option' do
      product = Product.create!(name: "Bike", category: "bicycle", description: "desc", is_active: true)
      part = product.parts.create!(name: "Handlebars")
      option = part.part_options.create!(name: "A", base_price: 100, stock_status: "available")
      context = part.part_options.create!(name: "B", base_price: 50, stock_status: "available")

      option.conditional_prices.create!(context_option: context, price_override: 80)

      get "http://localhost:3000/api/part_options/#{option.id}/conditional_prices", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first['context_option_id']).to eq(context.id)
      expect(json.first['price_override'].to_f).to eq(80.0)
    end

    it 'returns all conditional prices for a given part option' do
      product = Product.create!(name: "Bike XL", category: "bicycle", description: "desc", is_active: true)
      part = product.parts.create!(name: "Handlebars")
      option = part.part_options.create!(name: "A", base_price: 100, stock_status: "available")
      context_option1 = part.part_options.create!(name: 'X', base_price: 90, stock_status: 'available')
      context_option2 = part.part_options.create!(name: 'Y', base_price: 95, stock_status: 'available')
    
      option.conditional_prices.create!(context_option: context_option1, price_override: 85)
      option.conditional_prices.create!(context_option: context_option2, price_override: 88)
    
      get "http://localhost:3000/api/part_options/#{option.id}/conditional_prices", headers: headers
    
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
      expect(json.first['price_override'].to_f).to eq(85.0)
    end    
  end

  describe 'POST /api/part_options/:part_option_id/conditional_prices' do
    let(:product) { Product.create!(name: "Bike", category: "bicycle", description: "desc", is_active: true) }
    let(:part) { product.parts.create!(name: "Handlebar") }
    let(:option) { part.part_options.create!(name: "Steel", base_price: 100, stock_status: "available") }
    let(:context_option) { part.part_options.create!(name: "Carbon", base_price: 150, stock_status: "available") }

    it 'creates a conditional price and returns 201' do
      post "http://localhost:3000/api/part_options/#{option.id}/conditional_prices",
        params: {
          conditional_price: {
            context_option_id: context_option.id,
            price_override: 125.00
          }
        },
        headers: headers

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['context_option_id']).to eq(context_option.id)
      expect(json['price_override'].to_f).to eq(125.0)
    end

    it 'returns 422 when required attributes are missing or invalid' do
      post "http://localhost:3000/api/part_options/#{option.id}/conditional_prices",
        params: {
          conditional_price: {
            context_option_id: nil,      # missing
            price_override: nil          # missing
          }
        },
        headers: headers
    
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Context option must exist")
      expect(json['errors']).to include("Price override can't be blank")
    end    
  end

  describe 'PATCH /api/conditional_prices/:id' do
    it 'updates an existing conditional price' do
      product = Product.create!(name: 'Update Test', category: 'bicycle', description: 'desc', is_active: true)
      part = product.parts.create!(name: 'Frame')
      option = part.part_options.create!(name: 'Steel', base_price: 100, stock_status: 'available')
      context_option = part.part_options.create!(name: 'Titanium', base_price: 120, stock_status: 'available')
  
      price = option.conditional_prices.create!(
        context_option: context_option,
        price_override: 90.0
      )
  
      patch "http://localhost:3000/api/conditional_prices/#{price.id}", params: {
        conditional_price: {
          price_override: 95.0
        }
      }, headers: headers
  
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['price_override'].to_f).to eq(95.0)
    end
  end
  
  describe 'DELETE /api/conditional_prices/:id' do
    it 'removes the conditional price and returns 204' do
      product = Product.create!(name: 'Test Bike', category: 'bicycle', description: 'Test', is_active: true)
      part = product.parts.create!(name: 'Wheels')
      option_a = part.part_options.create!(name: 'Steel', base_price: 100, stock_status: 'available')
      option_b = part.part_options.create!(name: 'Carbon', base_price: 150, stock_status: 'available')
  
      price = option_a.conditional_prices.create!(context_option: option_b, price_override: 80)
  
      delete "http://localhost:3000/api/conditional_prices/#{price.id}", headers: headers
  
      expect(response).to have_http_status(:no_content)
      expect(ConditionalPrice.find_by(id: price.id)).to be_nil
    end
  end
  
end
