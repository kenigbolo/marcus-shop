module Api
  class CartItemsController < ApplicationController
    def create
      cart = Cart.find_by!(id: params[:cart_id], user_id: Current.user_id)

      product = Product.find(params[:product_id])
      selected_options = PartOption.where(id: params[:selected_option_ids])

      # Create cart item
      cart_item = cart.cart_items.create!(
        product: product,
        quantity: params[:quantity] || 1
      )

      selected_options.each do |option|
        # Handle conditional price overrides
        context_options = selected_options - [option]
        conditional = option.conditional_prices.find do |cp|
          context_options.map(&:id).include?(cp.context_option_id)
        end

        price = conditional&.price_override || option.base_price

        cart_item.cart_item_options.create!(
          part_option: option,
          price_applied: price
        )
      end

      render json: cart_item, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    def destroy
      cart_item = CartItem.find_by!(id: params[:id], cart_id: params[:cart_id])
      cart_item.destroy
      head :no_content
    end    
  end
end

