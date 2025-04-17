class Api::PartOptionsController < ApplicationController
  def index
    part = Part.find(params[:part_id])
    render json: part.part_options
  end
  def create
    part = Part.find(params[:part_id])
    option = part.part_options.create!(part_option_params)
    render json: option, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ArgumentError => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def update
    option = PartOption.find(params[:id])
    option.update!(part_option_params)
    render json: option
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue ArgumentError => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def destroy
    option = PartOption.find(params[:id])
    option.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end
  

  private

  def part_option_params
    params.require(:part_option).permit(:name, :base_price, :stock_status, :stock_count)
  end
end
