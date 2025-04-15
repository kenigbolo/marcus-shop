module Api
  class ConditionalPricesController < ApplicationController
    def index
      option = PartOption.find(params[:part_option_id])
      render json: option.conditional_prices
    end

    def create
      option = PartOption.find(params[:part_option_id])
      conditional_price = option.conditional_prices.create!(conditional_price_params)
      render json: conditional_price, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    def update
      price = ConditionalPrice.find(params[:id])
      price.update!(conditional_price_params)
      render json: price
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Not found' }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    end        

    private

    def conditional_price_params
      params.require(:conditional_price).permit(:context_option_id, :price_override)
    end
  end
end
