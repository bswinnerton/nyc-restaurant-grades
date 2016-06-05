module Graph
  module Types
    RootQuery = GraphQL::ObjectType.define do
      name "RootQuery"
      description "The query root."

      field :node, :field => Types::NodeIdentification.field
    end
  end
end
