class Api::PartsController < ApplicationController
  def index
    product = Product.find(params[:product_id])
    render json: product.parts.includes(:part_options)
  end

  def create
    product = Product.find(params[:product_id])
    part = product.parts.create!(part_params)
    render json: part, status: :created
  end

  def update
    part = Part.find(params[:id])
    part.update!(params.require(:part).permit(:name))
    render json: part
  end

  def destroy
    part = Part.find(params[:id])
    part.destroy
    head :no_content
  end

  private

  def part_params
    params.require(:part).permit(:name)
  end
end
