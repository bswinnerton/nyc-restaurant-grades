class Inspection < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  self.inheritance_column = 'sti_type'

  belongs_to :restaurant
  has_many :violations

  def url
    api_v1_restaurant_inspection_url(restaurant, self)
  end

  def restaurant_url
    api_v1_restaurant_url(restaurant)
  end

  def violations_url
    api_v1_restaurant_inspection_violations_url(restaurant, self)
  end

  def as_json(options = {})
    {
      id: id,
      type: type,
      score: score,
      grade: grade,
      inspected_at: inspected_at,
      graded_at: graded_at,
      url: url,
      restaurant_url: restaurant_url,
      violations_url: violations_url,
    }
  end
end
