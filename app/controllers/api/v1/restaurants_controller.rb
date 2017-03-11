class Api::V1::RestaurantsController < ApplicationController
  def index
    restaurants = Restaurant.first(30)
    render json: restaurants
  end

  def show
    restaurant = Restaurant.find(params[:id])
    render json: restaurant
  end
end
