class Api::V1::InspectionsController < ApplicationController
  def index
    restaurant  = Restaurant.find(params[:restaurant_id])
    inspections = restaurant.inspections.first(30)
    render json: inspections
  end

  def show
    inspection = Inspection.find(params[:id])
    render json: inspection
  end
end
