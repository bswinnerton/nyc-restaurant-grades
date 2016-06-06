module Graph
  module Types
    Inspection = GraphQL::ObjectType.define do
      name "Inspection"
      description "A NYC health inspection."

      interfaces [NodeIdentification.interface]
      global_id_field :id

      field :type,                    types.String
      field :violationDescription,    types.String,   property: :violation_description
      field :violationCode,           types.String,   property: :violation_code
      field :grade,                   types.String
      field :score,                   types.Int
      field :inspectedAt,             !types.String,  property: :inspected_at
      field :gradedAt,                types.String,   property: :graded_at

      field :restaurant, -> { !Types::Restaurant } do
        resolve -> (object, arguments, context) do
          object.restaurant
        end
      end
    end
  end
end
