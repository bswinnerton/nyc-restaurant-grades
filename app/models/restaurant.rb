class Restaurant < ApplicationRecord
  include Rails.application.routes.url_helpers

  MAX_COUNT = 30

  enum borough: ['BRONX', 'BROOKLYN', 'MANHATTAN', 'STATEN_ISLAND', 'QUEENS']

  has_many :inspections

  validates :camis, uniqueness: true

  def address
    "#{building_number} #{street}, #{borough.humanize}, New York #{zipcode}"
  end

  def grade
    return unless last_inspection
    last_inspection.grade
  end

  def url
    api_v1_restaurant_url(self)
  end

  def inspections_url
    api_v1_restaurant_inspections_url(self)
  end

  def as_json(options = {})
    {
      id: id,
      name: name,
      grade: grade,
      camis: camis,
      address: address,
      cuisine: cuisine,
      url: url,
      inspections_url: inspections_url,
    }
  end

  private

  def last_inspection
    inspections.where.not(grade: nil).order(inspected_at: :desc).last
  end
end
