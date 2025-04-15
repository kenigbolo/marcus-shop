module Api
  class CartsController < ApplicationController
    def show
      cart = Cart.includes(
        cart_items: [
          :product,
          { cart_item_options: :part_option }
        ]
      ).find_by!(id: params[:id], user_id: Current.user_id)

      render json: cart, include: [
        'cart_items.product',
        'cart_items.cart_item_options',
        'cart_items.cart_item_options.part_option',
        'cart_items.cart_item_options.part_option.part'
      ]
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue ArgumentError => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
    end

    def create
      cart = Cart.create!(user_id: Current.user_id)
      render json: cart, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue ArgumentError => e
      render json: { errors: [e.message] }, status: :unprocessable_entity
    end  
  end
end
