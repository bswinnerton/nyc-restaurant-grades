class Violation < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :inspection
  has_one :restaurant, through: :inspection

  validates :inspection_id, presence: true
  #validates :code, uniqueness: { scope: :inspection_id }

  def url
    api_v1_restaurant_inspection_violation_url(restaurant, inspection, self)
  end

  def inspection_url
    api_v1_restaurant_inspection_url(restaurant, inspection)
  end

  def restaurant_url
    api_v1_restaurant_url(restaurant)
  end

  def as_json(options = {})
    {
      id: id,
      description: description,
      code: code,
      url: url,
      inspection_url: inspection_url,
      restaurant_url: restaurant_url,
    }
  end
end
