module Graph
  module Types
    RestaurantBoroughEnum = GraphQL::EnumType.define do
      name "RestaurantBorough"
      description "The borough in which the Restaurant resides."

      ::Restaurant.boroughs.each { |name, _| value(name, name.titleize) }
    end

    Restaurant = GraphQL::ObjectType.define do
      name "Restaurant"
      description "A place of business serving food in New York City"

      interfaces [NodeIdentification.interface]
      global_id_field :id

      field :name,            !types.String,  "The 'doing-business-as' value of the Restaurant."
      field :camis,           !types.String,  "The unique identifier of the Restaurant."
      field :building_number, types.String,   "The street number of the Restaurant."
      field :street,          types.String,   "The street name of the Restaurant."
      field :zipcode,         types.String,   "The zip code of the Restaurant."
      field :cuisine,         types.String,   "The cuisine of the Restaurant."
      field :borough,         RestaurantBoroughEnum

      connection :inspections, -> { Types::Inspection.connection_type } do
        description "List the inspections of the Restaurant."

        resolve -> (object, arguments, context) do
          object.inspections
        end
      end
    end
  end
end
