module Graph
  module Types
    Violation = GraphQL::ObjectType.define do
      name 'Violation'
      description 'A NYC health inspection violation.'

      implements GraphQL::Relay::Node.interface
      global_id_field :id

      field :description do
        type types.String
        description 'The description of the violation.'
      end

      field :code do
        type types.String
        description 'The violation code cited.'
      end

      field :inspection do
        type -> { Types::Inspection }
        description 'The inspection this violation was a part of.'
      end
    end
  end
end
