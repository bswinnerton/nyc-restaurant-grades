module Graph
  module Types
    Restaurant = GraphQL::ObjectType.define do
      name 'Restaurant'
      description 'A place of business serving food in New York City'

      interfaces [NodeIdentification.interface]
      global_id_field :id

      field :name,            !types.String,  'The doing-business-as value.'
      field :camis,           !types.String,  'The unique identifier.'
      field :buildingNumber,  types.String,   'The street number.', property: :building_number
      field :street,          types.String,   'The street name.'
      field :zipcode,         types.String,   'The zip code.'
      field :cuisine,         types.String,   'The cuisine.'
      field :grade,           types.String,   'The latest grade of an inspection.'
      field :borough,         -> { RestaurantBoroughEnum }

      connection :inspections, -> { Types::Inspection.connection_type } do
        description 'List the inspections.'

        resolve -> (object, arguments, context) do
          object.inspections
        end
      end
    end
  end
end
