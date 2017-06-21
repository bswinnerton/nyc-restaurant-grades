module Graph
  module Connections
    Inspections = Types::Inspection.define_connection do
      name "InspectionsConnection"

      field :totalCount do
        type types.Int
        resolve -> (obj, args, ctx) { obj.nodes.count }
      end
    end
  end
end
