module Graph
  module Loaders
    class ForeignKeyLoader < GraphQL::Batch::Loader
      def initialize(model, foreign_key)
        @model        = model
        @foreign_key  = foreign_key
      end

      def perform(foreign_ids)
        records = model.where(foreign_key => foreign_ids.uniq).to_a

        foreign_ids.each do |foreign_id|
          matching_records = records.select do |record|
            record.send(foreign_key) == foreign_id
          end

          fulfill(foreign_id, matching_records)
        end
      end

      private

      attr_reader :model, :foreign_key
    end
  end
end
