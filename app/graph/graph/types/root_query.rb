require 'graph/enum/restaurant_borough_enum'

module Graph
  module Types
    RootQuery = GraphQL::ObjectType.define do
      name 'RootQuery'
      description 'The query root.'

      field :node, GraphQL::Relay::Node.field

      field :restaurant do
        type -> { Types::Restaurant }
        description 'Perform a search for one restaurant.'

        argument :name, types.String
        argument :borough, Types::RestaurantBoroughEnum

        resolve -> (object, arguments, context) do
          name = arguments['name']

          if arguments['borough']
            borough = ::Restaurant.boroughs[arguments['borough']]
            ::Restaurant.find_by(name: name, borough: borough)
          else
            ::Restaurant.find_by(name: name)
          end
        end
      end

      field :restaurants do
        type -> { !types[Types::Restaurant] }
        description 'Perform a search across all Restaurants.'

        argument :name, types.String
        argument :borough, Types::RestaurantBoroughEnum

        resolve -> (object, arguments, context) do
          name    = arguments['name']
          borough = ::Restaurant.boroughs[arguments['borough']]

          scope = if name && borough
                    ::Restaurant.where(name: name, borough: borough)
                  elsif name
                    ::Restaurant.where(name: name)
                  elsif borough
                    ::Restaurant.where(borough: borough)
                  else
                    ::Restaurant.all
                  end

          scope.limit(::Restaurant::MAX_COUNT)
        end
      end

      connection :paginatedRestaurants do
        type -> { !Connections::Restaurants }
        description 'Perform a search across all Restaurants and return a Relay connection.'

        argument :name, types.String
        argument :borough, Types::RestaurantBoroughEnum

        resolve -> (object, arguments, context) do
          name    = arguments['name']
          borough = ::Restaurant.boroughs[arguments['borough']]

          if name && borough
            ::Restaurant.where(name: name, borough: borough)
          elsif name
            ::Restaurant.where(name: name)
          elsif borough
            ::Restaurant.where(borough: borough)
          else
            ::Restaurant.all
          end
        end
      end

      field :inspections do
        type -> { !types[Types::Inspection] }
        description 'Perform a search across all Inspections.'

        argument :grade, types.String

        resolve -> (object, arguments, context) do
          grade = arguments['grade']

          scope = if grade
                    ::Inspection.includes(:restaurant).where(grade: grade)
                  else
                    ::Inspection.includes(:restaurant).all
                  end

          scope.limit(::Inspection::MAX_COUNT)
        end
      end

      connection :paginatedInspections do
        type -> { !Connections::Inspections }
        description 'Perform a search across all Inspections.'

        argument :grade, types.String

        resolve -> (object, arguments, context) do
          grade = arguments['grade']

          if grade
            ::Inspection.includes(:restaurant).where(grade: grade)
          else
            ::Inspection.includes(:restaurant).all
          end
        end
      end
    end
  end
end
