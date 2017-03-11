module Graph
  module Types
    Restaurant = GraphQL::ObjectType.define do
      name 'Restaurant'
      description 'A place of business serving food in New York City'

      implements GraphQL::Relay::Node.interface
      global_id_field :id

      field :name do
        type !types.String
        description 'The doing-business-as value.'
      end

      field :camis do
        type !types.String
        description 'The unique identifier.'
      end

      field :buildingNumber do
        type types.String
        description 'The street number.'
        property :building_number
      end

      field :street do
        type types.String
        description 'The street name.'
      end

      field :zipcode do
        type types.String
        description 'The zip code.'
      end

      field :phoneNumber do
        type types.String
        description 'The phone number.'
        property :phone_number
      end

      field :cuisine do
        type types.String
        description 'The cuisine.'
      end

      field :grade do
        type types.String
        description 'The latest grade of an inspection.'
      end

      field :borough do
        type -> { RestaurantBoroughEnum }
      end

      connection :inspections do
        type -> { Types::Inspection.connection_type }
        description 'List the inspections.'

        resolve -> (object, arguments, context) do
          object.inspections.order(inspected_at: :desc)
        end
      end
    end
  end
end
