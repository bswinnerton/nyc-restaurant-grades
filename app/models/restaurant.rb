class Restaurant < ActiveRecord::Base
  enum borough: ['BRONX', 'BROOKLYN', 'MANHATTAN', 'STATEN_ISLAND', 'QUEENS']

  has_many :inspections

  def grade
    inspections.where.not(grade: nil).order(inspected_at: :desc).last.grade
  end
end
