module Graph
  module Types
    Restaurant = GraphQL::ObjectType.define do
      name "Restaurant"
      description "A place of business serving food in New York City"

      interfaces [NodeIdentification.interface]
      global_id_field :id

      field :name,            !types.String, "The 'doing-business-as' value of the Restaurant."
      field :camis,           !types.String, "The unique identifier of the Restaurant."
      field :building_number, types.String, "The street number of the Restaurant."
      field :street,          types.String, "The street name of the Restaurant."
      field :zipcode,         types.String, "The zip code of the Restaurant."
      field :cuisine,         types.String, "The cuisine of the Restaurant."
    end
  end
end
