require 'rails_helper'

RSpec.describe 'Parts API - Index', type: :request do
  # Index endpoint (GET)
  describe 'GET /api/products/:product_id/parts' do
    let(:headers) { { 'HTTP_X_USER_ID' => 'test-user-123' } }

    let!(:product) do
      Product.create!(
        name: 'Bike with Parts',
        category: 'bicycle',
        description: 'Product with parts',
        is_active: true
      )
    end

    let!(:part1) { Part.create!(name: 'Wheels', product: product) }
    let!(:part2) { Part.create!(name: 'Frame', product: product) }
    let!(:option1) { PartOption.create!(name: 'Mountain', base_price: 50, stock_status: :available, part: part1) }
    let!(:option2) { PartOption.create!(name: 'Road', base_price: 60, stock_status: :available, part: part2) }

    it 'returns all parts for the given product, including part options' do
      get "http://localhost:3000/api/products/#{product.id}/parts", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
      expect(json.map { |p| p['name'] }).to contain_exactly('Wheels', 'Frame')

      # Confirm part options are included
      wheels = json.find { |p| p['name'] == 'Wheels' }
      frame = json.find { |p| p['name'] == 'Frame' }

      expect(wheels['part_options'].first['name']).to eq('Mountain')
      expect(frame['part_options'].first['name']).to eq('Road')
    end
  end

  # Create endpoint (POST)
  describe 'POST /api/products/:product_id/parts' do
    let(:headers) { { 'HTTP_X_USER_ID' => 'test-user-123' } }

    let!(:product) do
      Product.create!(
        name: 'Bike for New Part',
        category: 'bicycle',
        description: 'Ready for parts',
        is_active: true
      )
    end

    context 'with valid attributes' do
      it 'creates a new part and returns status 201' do
        post "http://localhost:3000/api/products/#{product.id}/parts",
          params: { part: { name: 'Brakes' } },
          headers: headers

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['name']).to eq('Brakes')
      end
    end

    context 'with invalid attributes' do
      it 'returns an error and status 422' do
        post "http://localhost:3000/api/products/#{product.id}/parts",
          params: { part: { name: '' } },
          headers: headers

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end

  # Edit/Modify endpoint (PATCH)
  describe 'PATCH /api/parts/:id' do
    let(:headers) { { 'HTTP_X_USER_ID' => 'test-user-123' } }
    let!(:product) do
      Product.create!(
        name: 'Speedster',
        category: 'bicycle',
        description: 'Fast',
        is_active: true
      )
    end

    let!(:part) { Part.create!(name: 'Handlebar', product: product) }

    context 'with valid attributes' do
      it 'updates the part name and returns the updated part' do
        patch "http://localhost:3000/api/parts/#{part.id}",
          params: { part: { name: 'Updated Handlebar' } },
          headers: { 'HTTP_X_USER_ID' => 'test-user-123' }
    
        expect(response).to have_http_status(:ok)
    
        json = JSON.parse(response.body)
        expect(json['name']).to eq('Updated Handlebar')
      end
    end

    context 'with invalid attributes' do
      it 'returns an error and status 422' do
        patch "http://localhost:3000/api/parts/#{part.id}",
          params: { part: { name: '' } },
          headers: { 'HTTP_X_USER_ID' => 'test-user-123' }

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end

  # Delete enpoint (DELETE)
  describe 'DELETE /api/parts/:id' do
    let(:headers) { { 'HTTP_X_USER_ID' => 'test-user-123' } }
    let!(:product) do
      Product.create!(
        name: 'Speedster',
        category: 'bicycle',
        description: 'Fast',
        is_active: true
      )
    end

    let!(:part) { Part.create!(name: 'saddle', product: product) }

    it 'deletes the part and returns no content' do
      delete "http://localhost:3000/api/parts/#{part.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(Part.find_by(id: part.id)).to be_nil
    end

    it 'returns 404 if product does not exist' do
      delete "http://localhost:3000/api/parts/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Part not found')
    end
  end
end
