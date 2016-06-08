module Graph
  module Types
    Inspection = GraphQL::ObjectType.define do
      name 'Inspection'
      description 'A NYC health inspection.'

      interfaces [NodeIdentification.interface]
      global_id_field :id

      field :type,                 types.String,  'The type of inspection.'
      field :violationDescription, types.String,  'The description of the violation.', property: :violation_description
      field :violationCode,        types.String,  'The violation code cited.', property: :violation_code
      field :grade,                types.String,  'The grade received.'
      field :score,                types.Int,     'The numeric score received.'
      field :inspectedAt,          !types.String, 'The timestamp of the inspection.', property: :inspected_at
      field :gradedAt,             types.String,  'The timestamp of when the grade was received.',  property: :graded_at

      field :restaurant, -> { !Types::Restaurant } do
        description 'The restaurant associated with the inspection.'

        resolve -> (object, arguments, context) do
          object.restaurant
        end
      end
    end
  end
end
