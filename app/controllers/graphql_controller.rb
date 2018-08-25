class GraphqlController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    result = Graph::Schema.execute(params[:query], variables: query_variables)
    render json: result
  end

  private

  def query_variables
    variables = params[:variables]

    if variables.present?
      JSON.parse(vars)
    end
  end
end
