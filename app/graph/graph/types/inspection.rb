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
          Loaders::RecordLoader.for(::Restaurant).load(object.restaurant_id)
        end
      end

      field :violations do
        type -> { types[Types::Violation] }
        description 'The violations received in the inspection.'

        resolve -> (inspection, arguments, context) do
          Loaders::ForeignKeyLoader.for(::Violation, :inspection_id).load(inspection.id)
        end
      end

      connection :paginatedViolations do
        type -> { !Connections::Violations }
        description 'The violations received in the inspection as a Relay connection.'

        resolve -> (inspection, arguments, context) do
          Loaders::RelayForeignKeyLoader.for(::Violation, :inspection_id).load(inspection.id)
        end
      end
    end
  end
end
