module Graph
  module Types
    RootQuery = GraphQL::ObjectType.define do
      name "RootQuery"
      description "The query root."

      field :node, :field => Types::NodeIdentification.field

      field :restaurant do
        type -> { !Types::Restaurant }
        description "Perform a search across all Restaurants."

        argument :name, !types.String

        resolve -> (object, arguments, context) do
          ::Restaurant.find_by(name: arguments['name'])
        end
      end
    end
  end
end
