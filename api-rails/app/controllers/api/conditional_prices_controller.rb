module Api
  class ConditionalPricesController < ApplicationController
    def index
      option = PartOption.find(params[:part_option_id])
      render json: option.conditional_prices
    end
  end
end
