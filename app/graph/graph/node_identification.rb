module Graph
  NodeIdentification = GraphQL::Relay::GlobalNodeIdentification.define do
    object_from_id -> (id, context) do
      type_name, id = NodeIdentification.from_global_id(id)
      type_name.constantize.find(id)
    end

    type_from_object -> (object) do
      Schema.types[object.class.name]
    end
  end
end
