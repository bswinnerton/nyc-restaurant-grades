class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    result = Graph::Schema.execute(params[:query], variables: params[:variables])
    render json: result
  end
end
