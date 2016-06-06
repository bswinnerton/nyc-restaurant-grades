module Graph
  module Types
    Inspection = GraphQL::ObjectType.define do
      name "Inspection"
      description "A NYC health inspection."

      interfaces [NodeIdentification.interface]
      global_id_field :id

      #TODO: Convert all snake_case to camelCase

      field :type,                    types.String
      field :violation_description,   types.String
      field :violation_code,          types.String
      field :grade,                   types.String
      field :score,                   types.Int
      field :inspected_at,            !types.String
      field :graded_at,               types.String

      field :restaurant, !Types::Restaurant do
        resolve -> (object, arguments, context) do
          object.restaurant
        end
      end
    end
  end
end
