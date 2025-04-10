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
        'cart_items.cart_item_options.part_option'
      ]
    end

    def create
      cart = Cart.create!(user_id: Current.user_id)
      render json: cart, status: :created
    end

    def index
    end
  end
end



