require 'graph/enum/restaurant_borough_enum'

module Graph
  module Types
    RootQuery = GraphQL::ObjectType.define do
      name "RootQuery"
      description "The query root."

      field :node, :field => Types::NodeIdentification.field

      field :restaurant do
        type -> { !Types::Restaurant }
        description "Perform a search across all Restaurants."

        argument :name, types.String
        argument :borough, Types::RestaurantBoroughEnum

        resolve -> (object, arguments, context) do
          ::Restaurant.find_by(name: arguments['name'])
        end
      end

      connection :restaurants, -> { !Types::Restaurant.connection_type } do
        description "Perform a search across all Restaurants."
        type -> { !Types::Restaurant }

        argument :name, types.String
        argument :borough, Types::RestaurantBoroughEnum

        resolve -> (object, arguments, context) do
          name = arguments['name']
          borough = arguments['borough']

          if name && borough
            ::Restaurant.where(name: name, borough: borough)
          elsif name
            ::Restaurant.find_by(name: arguments['name'])
          elsif borough
            ::Restaurant.send(borough)
          end
        end
      end
    end
  end
end
