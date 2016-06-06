class Restaurant < ActiveRecord::Base
  enum borough: ['BRONX', 'BROOKLYN', 'MANHATTAN', 'STATEN_ISLAND', 'QUEENS']

  has_many :inspections
end
