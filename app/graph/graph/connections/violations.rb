module Graph
  module Connections
    Violations = Types::Violation.define_connection do
      name "ViolationsConnection"

      field :totalCount do
        type types.Int
        resolve -> (obj, args, ctx) { obj.nodes.count }
      end
    end
  end
end
