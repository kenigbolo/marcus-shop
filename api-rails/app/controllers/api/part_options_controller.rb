# class Api::PartOptionsController < ApplicationController
#   def create
#     part = Part.find(params[:part_id])
#     option = part.part_options.create!(part_option_params)
#     render json: option, status: :created
#   rescue ActiveRecord::RecordInvalid => e
#     render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
#   end

#   def update
#     option = PartOption.find(params[:id])
#     option.update!(part_option_params)
#     render json: option
#   rescue ActiveRecord::RecordInvalid => e
#     render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
#   end

#   def destroy
#     option = PartOption.find(params[:id])
#     option.destroy
#     head :no_content
#   end

#   private

#   def part_option_params
#     params.require(:part_option).permit(:name, :base_price, :stock_status)
#   end
# end
class Api::PartOptionsController < ApplicationController
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
  end

  private

  def part_option_params
    params.require(:part_option).permit(:name, :base_price, :stock_status)
  end
end
