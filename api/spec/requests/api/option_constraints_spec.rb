# spec/requests/api/option_constraints_spec.rb
require 'rails_helper'

RSpec.describe 'OptionConstraints API', type: :request do
  let(:headers) { { 'HTTP_X_ADMIN_ID' => 'admin-123' } }

  describe 'GET /api/part_options/:part_option_id/constraints' do
    let!(:product) { Product.create!(name: "Roadster", category: "bicycle", description: "Fast and light", is_active: true) }
    let!(:part)    { product.parts.create!(name: "Wheels") }
    let!(:option_a) { part.part_options.create!(name: "Mountain Wheels", base_price: 100, stock_status: 'available') }
    let!(:option_b) { part.part_options.create!(name: "Road Wheels", base_price: 90, stock_status: 'available') }

    let!(:constraint) do
      OptionConstraint.create!(
        source_option: option_a,
        target_option: option_b,
        constraint_type: :prohibits
      )
    end

    it 'returns all constraints for the source option' do
      get "http://localhost:3000/api/part_options/#{option_a.id}/constraints", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json.length).to eq(1)
      expect(json.first['constraint_type']).to eq('prohibits')
      expect(json.first['target_option_id']).to eq(option_b.id)
      expect(json.first['target_option']['name']).to eq(option_b.name)
    end
  end

  describe 'POST /api/part_options/:part_option_id/constraints' do
    let!(:product) { Product.create!(name: 'Test', category: 'bikes', description: 'sample', is_active: true) }
    let!(:part) { product.parts.create!(name: 'Wheels') }
    let!(:source_option) { part.part_options.create!(name: 'Mountain', base_price: 100, stock_status: 'available') }
    let!(:target_option) { part.part_options.create!(name: 'Full Suspension', base_price: 150, stock_status: 'available') }
  
    it 'creates a new option constraint and returns 201' do
      post "http://localhost:3000/api/part_options/#{source_option.id}/constraints", params: {
        option_constraint: {
          target_option_id: target_option.id,
          constraint_type: 'prohibits'
        }
      }, headers: { 'X-User-ID' => SecureRandom.uuid }
  
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['target_option_id']).to eq(target_option.id)
      expect(json['constraint_type']).to eq('prohibits')
    end
  
    it 'returns 422 with invalid data' do
      post "http://localhost:3000/api/part_options/#{source_option.id}/constraints", params: {
        option_constraint: {
          target_option_id: nil,
          constraint_type: nil
        }
      }, headers: { 'X-User-ID' => SecureRandom.uuid }
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_an(Array)
      expect(json['errors']).to include("Target option must exist")
    end
  end
  
  describe 'PATCH /api/option_constraints/:id' do
    let!(:product) { Product.create!(name: 'Test', category: 'bikes', description: 'sample', is_active: true) }
    let!(:part) { product.parts.create!(name: 'Frame') }
    let!(:source) { part.part_options.create!(name: 'Steel', base_price: 100, stock_status: 'available') }
    let!(:target) { part.part_options.create!(name: 'Aluminum', base_price: 110, stock_status: 'available') }
    let!(:constraint) { OptionConstraint.create!(source_option: source, target_option: target, constraint_type: :prohibits) }
  
    it 'updates the constraint type' do
      patch "http://localhost:3000/api/option_constraints/#{constraint.id}", params: {
        option_constraint: { constraint_type: 'requires' }
      }, headers: { 'X-User-ID' => SecureRandom.uuid }
  
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['constraint_type']).to eq('requires')
    end
  
    it 'returns 422 with invalid data' do
      patch "http://localhost:3000/api/option_constraints/#{constraint.id}", params: {
        option_constraint: { constraint_type: nil }
      }, headers: { 'X-User-ID' => SecureRandom.uuid }
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Constraint type can't be blank")
    end
  end  
end
