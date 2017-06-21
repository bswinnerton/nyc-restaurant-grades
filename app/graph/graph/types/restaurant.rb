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

      field :address do
        type types.String
        description 'The address of the restaurant.'
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

      field :inspections do
        type -> { types[Types::Inspection] }
        description 'List the inspections.'

        resolve -> (restaurant, arguments, context) do
          #TODO: Use order(inspected_at: :desc)
          Loaders::ForeignKeyLoader.for(::Inspection, :restaurant_id).load(restaurant.id)
        end
      end

      connection :paginatedInspections do
        type -> { Connections::Inspections }
        description 'The inspections of the restaurant as a Relay connection.'

        resolve -> (restaurant, arguments, context) do
          #TODO: Use order(inspected_at: :desc)
          Loaders::ForeignKeyLoader.for(::Inspection, :restaurant_id).load(restaurant.id)
        end
      end
    end
  end
end
