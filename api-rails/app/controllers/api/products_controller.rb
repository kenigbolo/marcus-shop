module Api
  class ProductsController < ApplicationController
    def index
      products = Product.includes(parts: :part_options).where(is_active: true)
      render json: products
    end

    def show
      product = Product.includes(parts: :part_options).find(params[:id])
      render json: product, include: ['parts.part_options']
    end

    def create
      product = Product.create!(product_params)
      render json: product, status: :created
    end

    def update
      product = Product.find(params[:id])
      product.update!(product_params)
      render json: product
    end
    
    def destroy
      product = Product.find(params[:id])
      product.destroy
      head :no_content
    end    
    
    private
    
    def product_params
      params.require(:product).permit(:name, :category, :description, :is_active)
    end     
  end
end
