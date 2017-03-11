class GraphController < ApplicationController
  def create
    result = Graph::Schema.execute(params[:query], variables: params[:variables])
    render json: result
  end
end
