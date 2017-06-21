class Api::V1::RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.limit(Restaurant::MAX_COUNT)
    render json: restaurants
  end

  def show
    restaurant = Restaurant.find(params[:id])
    render json: restaurant
  end
end
