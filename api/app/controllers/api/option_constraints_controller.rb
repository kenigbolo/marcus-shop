module Api
  class OptionConstraintsController < ApplicationController
    before_action :set_source_option, only: [:index, :create]

    def index
      constraints = @source_option.source_constraints.includes(:target_option)

      render json: constraints
    end

    def create
      constraint = @source_option.source_constraints.build(option_constraint_params)
  
      if constraint.save
        render json: constraint, status: :created
      else
        render json: { errors: constraint.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      constraint = OptionConstraint.find(params[:id])
    
      if constraint.update(option_constraint_params)
        render json: constraint
      else
        render json: { errors: constraint.errors.full_messages }, status: :unprocessable_entity
      end
    end
        
  
    private
  
    def option_constraint_params
      params.require(:option_constraint).permit(:target_option_id, :constraint_type)
    end

    def set_source_option
      @source_option = PartOption.find(params[:part_option_id])
    end
  end
end

