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
      product = Product.new(product_params)
    
      if product.save
        render json: product, status: :created
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end    

    def update
      product = Product.find(params[:id])

      if product.update(product_params)
        render json: product
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def destroy
      product = Product.find(params[:id])
      product.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Product not found' }, status: :not_found
    end
        
    
    private
    
    def product_params
      params.require(:product).permit(:name, :category, :description, :is_active)
    end     
  end
end
