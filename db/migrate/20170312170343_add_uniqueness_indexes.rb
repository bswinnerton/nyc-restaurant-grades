class AddUniquenessIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :restaurants, :camis, unique: true
    add_index :inspections, [:restaurant_id, :inspected_at], unique: true
    add_index :violations, [:inspection_id, :code], unique: true
  end
end
