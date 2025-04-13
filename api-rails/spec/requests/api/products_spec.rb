require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  describe 'GET /api/products/:id' do
    it 'returns a product with parts and part options' do
      product = Product.create!(
        name: 'Test Bike',
        category: 'bicycle',
        description: 'Fast bike',
        is_active: true
      )

      part = Part.create!(name: 'Frame', product: product)
      PartOption.create!(name: 'Diamond', base_price: 100, stock_status: 'available', part: part)
      puts product.id

      get "http://localhost:3000/api/products/#{product.id}", headers: {
        'HTTP_X_USER_ID' => 'test-user-123'
      }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body['id']).to eq(product.id)
      expect(body['parts'].first['part_options'].first['name']).to eq('Diamond')
    end
  end
end
