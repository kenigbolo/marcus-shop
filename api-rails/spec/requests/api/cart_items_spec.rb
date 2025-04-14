require 'rails_helper'

RSpec.describe 'CartItems API', type: :request do
  let(:headers) { { 'HTTP_X_USER_ID' => '3f2c1de2-b879-4f0e-980f-16a48db451c7' } }

  describe 'POST /api/carts/:cart_id/items' do
    let!(:product) do
      Product.create!(name: "Mountain Bike", category: "bicycle", description: "Rugged", is_active: true)
    end
    let!(:part) { product.parts.create!(name: "Frame") }
    let!(:option) do
      part.part_options.create!(name: "Steel", base_price: 100, stock_status: "available")
    end
    let!(:cart) { Cart.create!(user_id: '3f2c1de2-b879-4f0e-980f-16a48db451c7') }

    it 'creates a cart item with selected options and returns status 201' do
      post "http://localhost:3000/api/carts/#{cart.id}/items", params: {
        product_id: product.id,
        quantity: 1,
        selected_option_ids: [option.id]
      }, headers: headers

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json['product']['id']).to eq(product.id)
    end

    it 'returns 404 when product is not found' do
      post "http://localhost:3000/api/carts/#{cart.id}/items", params: {
        product_id: 999999, # Invalid product ID
        quantity: 1,
        selected_option_ids: [option.id]
      }, headers: headers
      
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/carts/:cart_id/items/:id' do
    let!(:product) do
      Product.create!(name: "Road Bike", category: "bicycle", description: "Light", is_active: true)
    end
    let!(:part) { product.parts.create!(name: "Handlebars") }
    let!(:option) do
      part.part_options.create!(name: "Carbon", base_price: 150, stock_status: "available")
    end
    let!(:cart) { Cart.create!(user_id: '3f2c1de2-b879-4f0e-980f-16a48db451c7') }
    let!(:cart_item) { cart.cart_items.create!(product: product, quantity: 1) }
    let!(:cart_item_option) do
      cart_item.cart_item_options.create!(part_option: option, price_applied: 150)
    end

    it 'removes a cart item and returns 204' do
      delete "http://localhost:3000/api/carts/#{cart.id}/items/#{cart_item.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(CartItem.find_by(id: cart_item.id)).to be_nil
    end
  end
end
