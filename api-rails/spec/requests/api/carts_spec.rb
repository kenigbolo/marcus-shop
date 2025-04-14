require 'rails_helper'

RSpec.describe 'Carts API', type: :request do
  let(:user_id) { SecureRandom.uuid }
  let(:headers) { { 'HTTP_X_USER_ID' => user_id } }

  describe 'POST /api/carts' do
    it 'creates a new cart for the user and returns status 201' do
      post 'http://localhost:3000/api/carts', headers: headers

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json['user_id']).to eq(user_id)
    end
  end

  describe 'GET /api/carts/:id' do
    let!(:cart) { Cart.create!(user_id: user_id) }

    it 'returns the full cart with nested cart_items and options' do
      product = Product.create!(name: 'Speedster', category: 'bicycle', description: 'Fast', is_active: true)
      part = product.parts.create!(name: 'Frame')
      option = part.part_options.create!(name: 'Diamond', base_price: 100, stock_status: 'available')

      item = cart.cart_items.create!(product: product, quantity: 2)
      item.cart_item_options.create!(part_option: option, price_applied: 100)

      get "http://localhost:3000/api/carts/#{cart.id}", headers: headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['id']).to eq(cart.id)
      expect(json['cart_items'].first['product']['name']).to eq('Speedster')
      expect(json['cart_items'].first['cart_item_options'].first['part_option']['name']).to eq('Diamond')
    end

    it 'returns 404 if the cart does not exist or does not belong to user' do
      other_cart = Cart.create!(user_id: SecureRandom.uuid)

      get "http://localhost:3000/api/carts/#{other_cart.id}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
