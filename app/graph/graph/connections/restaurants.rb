module Graph
  module Connections
    Restaurants = Types::Restaurant.define_connection do
      name "RestaurantsConnection"

      field :totalCount do
        type types.Int
        resolve -> (obj, args, ctx) { obj.nodes.count }
      end
    end
  end
end
