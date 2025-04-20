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
end
