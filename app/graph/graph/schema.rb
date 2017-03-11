module Graph
  Schema = GraphQL::Schema.define do
    query Graph::Types::RootQuery

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
