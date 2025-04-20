module Api
  class OptionConstraintsController < ApplicationController
    def index
      option = PartOption.find(params[:part_option_id])
      constraints = option.source_constraints.includes(:target_option)

      render json: constraints
    end
  end
end
