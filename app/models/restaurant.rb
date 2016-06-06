class Restaurant < ActiveRecord::Base
  enum borough: ['BRONX', 'BROOKLYN', 'MANHATTAN', 'STATEN_ISLAND', 'QUEENS']

  has_many :inspections

  def grade
    return unless last_inspection
    last_inspection.grade
  end

  private

  def last_inspection
    inspections.where.not(grade: nil).order(inspected_at: :desc).last
  end
end
