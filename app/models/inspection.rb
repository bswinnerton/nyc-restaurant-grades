class Inspection < ActiveRecord::Base
  self.inheritance_column = "sti_type"

  belongs_to :restaurant
end
