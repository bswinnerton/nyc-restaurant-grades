module Graph
  module Types
    Inspection = GraphQL::ObjectType.define do
      name 'Inspection'
      description 'A NYC health inspection.'

      implements GraphQL::Relay::Node.interface
      global_id_field :id

      field :type do
        type types.String
        description 'The type of inspection.'
      end

      field :violationDescription do
        type types.String
        description 'The description of the violation.'
        property :violation_description
      end

      field :violationCode do
        type types.String
        description 'The violation code cited.'
        property :violation_code
      end

      field :grade do
        type types.String
        description 'The grade received.'
      end

      field :score do
        type types.Int
        description 'The numeric score received.'
      end

      field :inspectedAt do
        type !types.String
        description 'The timestamp of the inspection.'
        property :inspected_at
      end

      field :gradedAt do
        type types.String
        description 'The timestamp of when the grade was received.'
        property :graded_at
      end

      field :restaurant do
        type -> { !Types::Restaurant }
        description 'The restaurant associated with the inspection.'

        resolve -> (object, arguments, context) do
          object.restaurant
        end
      end
    end
  end
end
