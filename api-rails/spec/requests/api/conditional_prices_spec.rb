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
  end
end
