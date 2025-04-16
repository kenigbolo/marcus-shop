module Api
  class OptionConstraintsController < ApplicationController
    def index
      part_option = PartOption.find(params[:part_option_id])
      constraints = part_option.option_constraints

      render json: constraints
    end
  end
end
