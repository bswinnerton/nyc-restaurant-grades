class Api::V1::ViolationsController < ApplicationController
  def index
    inspection = Inspection.find(params[:inspection_id])
    violations = inspection.violations.first(30)
    render json: violations
  end

  def show
    violation = Violation.find(params[:id])
    render json: violation
  end
end
