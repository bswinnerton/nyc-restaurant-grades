module Graph
  # Allow for connection.nodes shorthand
  GraphQL::Relay::ConnectionType.default_nodes_field = true

  Schema = GraphQL::Schema.define do
    query Graph::Types::RootQuery

    lazy_resolve(Promise, :sync)
    instrument(:query, GraphQL::Batch::Setup)

    default_max_page_size 50

    object_from_id -> (id, context) do
      type_name, database_id = GraphQL::Schema::UniqueWithinType.decode(id)
      type_name.constantize.find(database_id)
    end

    id_from_object -> (object, type_definition, context) do
      GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.id)
    end

    resolve_type -> (object, context) do
      type_name = object.class.name.demodulize
      Graph::Schema.types[type_name]
    end
  end
end
