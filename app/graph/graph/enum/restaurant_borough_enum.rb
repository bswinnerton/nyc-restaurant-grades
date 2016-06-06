module Graph
  module Types
    RestaurantBoroughEnum = GraphQL::EnumType.define do
      name "RestaurantBorough"
      description "The borough in which the Restaurant resides."

      ::Restaurant.boroughs.each { |name, _| value(name, name.titleize) }
    end
  end
end
