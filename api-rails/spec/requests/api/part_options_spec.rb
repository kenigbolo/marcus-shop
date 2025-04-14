require 'rails_helper'

RSpec.describe 'PartOptions API', type: :request do
  let(:headers) { { 'HTTP_X_ADMIN_ID' => 'admin-123' } }

  # Create endpoint (POST)
  describe 'POST /api/parts/:part_id/part_options' do
    let(:product) { Product.create!(name: "Speedster", category: "bicycle", description: "Fast", is_active: true) }
    let(:part) { Part.create!(name: "Frame", product: product) }

    it 'creates a new part option and returns status 201' do
      post "http://localhost:3000/api/parts/#{part.id}/part_options",
        params: {
          part_option: {
            name: 'Diamond',
            base_price: 100,
            stock_status: 'available'
          }
        },
        headers: headers

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json['name']).to eq('Diamond')
      expect(json['base_price'].to_f).to eq(100.0)
      expect(json['stock_status']).to eq('available')
    end

    it 'returns 422 when stock_status is invalid' do
      post "http://localhost:3000/api/parts/#{part.id}/part_options", params: {
        part_option: {
          name: 'Diamond',
          base_price: 100,
          stock_status: 'ghost'
        }
      }, headers: headers
    
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("'ghost' is not a valid stock_status")
    end

    it 'returns 422 when required fields are missing' do
      post "http://localhost:3000/api/parts/#{part.id}/part_options", params: {
        part_option: {
          name: nil,
          base_price: nil,
          stock_status: 'available'
        }
      }, headers: headers
    
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Name can't be blank")
      expect(json['errors']).to include("Base price can't be blank")
    end
            
  end

  # Edit/Modify/Update endpoint (PATCH)
  describe 'PATCH /api/part_options/:id' do
    let!(:product) { Product.create!(name: 'Bike', category: 'bicycle', description: 'Fast', is_active: true) }
    let!(:part)    { product.parts.create!(name: 'Wheels') }
    let!(:option)  { part.part_options.create!(name: 'Mountain', base_price: 150, stock_status: 'available') }

    context 'with valid attributes' do
      it 'updates the part option and returns the updated resource' do
        patch "http://localhost:3000/api/part_options/#{option.id}", params: {
          part_option: {
            name: 'Updated Name',
            base_price: 175,
            stock_status: 'out_of_stock'
          }
        }, headers: headers

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['name']).to eq('Updated Name')
        expect(json['base_price'].to_f).to eq(175.0)
        expect(json['stock_status']).to eq('out_of_stock')
      end
    end

    context 'with invalid attributes' do
      it 'returns 422 when updating with invalid stock_status' do
        patch "http://localhost:3000/api/part_options/#{option.id}", params: {
          part_option: {
            stock_status: 'invisible'
          }
        }, headers: headers
      
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("'invisible' is not a valid stock_status")
      end
      
      it 'returns 422 when updating with missing name and price' do
        patch "http://localhost:3000/api/part_options/#{option.id}", params: {
          part_option: {
            name: nil,
            base_price: nil,
            stock_status: 'available'
          }
        }, headers: headers
      
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Name can't be blank")
        expect(json['errors']).to include("Base price can't be blank")
      end      
    end
  end
  # Delete endpoint (DELETE)
  describe 'DELETE /api/part_options/:id' do
    let!(:product) { Product.create!(name: 'Test Bike', category: 'bicycle', description: 'Speedy', is_active: true) }
    let!(:part)    { product.parts.create!(name: 'Handlebar') }
    let!(:option)  { part.part_options.create!(name: 'Aluminum', base_price: 80, stock_status: 'available') }

    it 'deletes the part option and returns 204' do
      expect {
        delete "http://localhost:3000/api/part_options/#{option.id}", headers: headers
      }.to change { PartOption.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 if the option does not exist' do
      delete "http://localhost:3000/api/part_options/999999", headers: headers

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to include("Couldn't find PartOption")
    end
  end
end