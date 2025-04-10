module Api
  class ProductsController < ApplicationController
    def index
      products = Product.includes(parts: :part_options).where(is_active: true)
      render json: products
    end

    def show
      product = Product.includes(parts: :part_options).find(params[:id])
      render json: product
    end
  end
end
