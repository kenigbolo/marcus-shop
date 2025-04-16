require 'rails_helper'

RSpec.describe 'OptionConstraints API', type: :request do
  let(:headers) { { 'HTTP_X_ADMIN_ID' => 'admin-123' } }

  describe 'GET /api/part_options/:part_option_id/constraints' do
    it 'returns all constraints for a part option' do
      product = Product.create!(name: "Sample", category: "bike", description: "desc", is_active: true)
      part = product.parts.create!(name: "Frame")
      parent = part.part_options.create!(name: "Option A", base_price: 100, stock_status: "available")
      related = part.part_options.create!(name: "Option B", base_price: 80, stock_status: "available")

      constraint = OptionConstraint.create!(
        part_option: parent,
        related_option: related,
        constraint_type: :prohibits
      )

      get "http://localhost:3000/api/part_options/#{parent.id}/constraints", headers: headers

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(constraint.related_option.id).to eq(related.id)
      expect(json.first["constraint_type"]).to eq("prohibits")
    end
  end
end
