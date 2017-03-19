module Graph
  module Loaders
    class ForeignKeyLoader < GraphQL::Batch::Loader
      def initialize(model, foreign_key)
        @model        = model
        @foreign_key  = foreign_key
      end

      def perform(foreign_id_sets)
        foreign_ids = foreign_id_sets.flatten.uniq
        records = model.where(foreign_key => foreign_ids).to_a

        foreign_id_sets.each do |foreign_id_set|
          matching_records = records.select do |record|
            foreign_id_set.include?(record.send(foreign_key))
          end

          fulfill(foreign_id_set, matching_records)
        end
      end

      private

      attr_reader :model, :foreign_key, :opts
    end
  end
end
