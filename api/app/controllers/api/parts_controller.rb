class Api::PartsController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    render json: product.parts.includes(:part_options)
  end

  def create
    product = Product.find(params[:product_id])
    part = product.parts.new(part_params)
  
    if part.save
      render json: part, status: :created
    else
      render json: { error: part.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
  

  def update
    part = Part.find(params[:id])
    if part.update(params.require(:part).permit(:name))
      render json: part
    else
      render json: { error: part.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    part = Part.find(params[:id])
    part.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Part not found' }, status: :not_found
  end

  private

  def part_params
    params.require(:part).permit(:name)
  end
end
