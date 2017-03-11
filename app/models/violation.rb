class Violation < ActiveRecord::Base
  belongs_to :inspection
  has_one :restaurant, through: :inspection
end
