require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let(:headers) { { 'HTTP_X_USER_ID' => 'test-user-123' } }
  # Index endpoint
  describe 'GET /api/products' do
    it 'returns only active products with basic fields and optionally parts' do
      active1 = Product.create!(
        name: 'Speedster',
        category: 'bicycle',
        description: 'Fast one',
        is_active: true
      )

      active2 = Product.create!(
        name: 'Skater Pro',
        category: 'skateboard',
        description: 'Slick deck',
        is_active: true
      )

      Product.create!(
        name: 'Hidden Bike',
        category: 'bicycle',
        description: 'Should not appear',
        is_active: false
      )

      get 'http://localhost:3000/api/products', headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      names = json.map { |p| p['name'] }

      expect(names).to include('Speedster', 'Skater Pro')
      expect(names).not_to include('Hidden Bike')

      json.each do |product|
        expect(product).to include('name', 'category', 'description', 'is_active')
      end
    end
  end

  # Show endpoint
  describe 'GET /api/products/:id' do
    it 'returns a product with its parts and part options' do
      product = Product.create!(
        name: 'Test Bike',
        category: 'bicycle',
        description: 'Fast bike',
        is_active: true
      )

      part = Part.create!(name: 'Wheels', product: product)
      PartOption.create!(name: 'Diamond', base_price: 100, stock_status: 'available', part: part)

      get "http://localhost:3000/api/products/#{product.id}", headers: headers

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body['id']).to eq(product.id)
      expect(body['parts'].first['part_options'].first['name']).to eq('Diamond')
    end
  end

  # Create endpoint
  describe 'POST /api/products' do
    context 'with valid attributes' do
      let(:valid_attributes) do
        {
          product: {
            name: 'New Bike',
            category: 'bicycle',
            description: 'An awesome bike',
            is_active: true
          }
        }
      end

      it 'creates a new product and returns 201' do
        expect {
          post 'http://localhost:3000/api/products', params: valid_attributes, headers: headers
        }.to change(Product, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['name']).to eq('New Bike')
        expect(json['category']).to eq('bicycle')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) do
        { product: { name: '', category: 'bicycle' } }
      end

      it 'returns an error and status 422' do
        post 'http://localhost:3000/api/products', params: invalid_attributes, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end
    end
  end

  # Edit/Modify endpoint (PATCH)
  describe 'PATCH /api/products/:id' do

    let!(:product) do
      Product.create!(
        name: 'Old Name',
        category: 'bicycle',
        description: 'Old description',
        is_active: true
      )
    end

    context 'with valid attributes' do
      let(:valid_params) do
        {
          product: {
            name: 'Updated Name',
            description: 'Updated description'
          }
        }
      end

      it 'updates the product and returns status 200' do
        patch "http://localhost:3000/api/products/#{product.id}", params: valid_params, headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Updated Name')
        expect(json['description']).to eq('Updated description')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) do
        {
          product: {
            name: ''
          }
        }
      end

      it 'returns a 422 error and does not update the product' do
        patch "http://localhost:3000/api/products/#{product.id}", params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present

        product.reload
        expect(product.name).to eq('Old Name') # unchanged
      end
    end
  end

  # Delete enpoint
  describe 'DELETE /api/products/:id' do

    let!(:product) do
      Product.create!(
        name: 'Deletable Product',
        category: 'bicycle',
        description: 'To be deleted',
        is_active: true
      )
    end

    it 'deletes the product and returns status 204' do
      delete "http://localhost:3000/api/products/#{product.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(Product.find_by(id: product.id)).to be_nil
    end

    it 'returns 404 if product does not exist' do
      delete "http://localhost:3000/api/products/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Product not found')
    end
  end
end
