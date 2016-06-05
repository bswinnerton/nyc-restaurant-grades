class CreateInspections < ActiveRecord::Migration
  def change
    create_table :inspections do |t|
      t.integer :restaurant_id
      t.text :type
      t.datetime :inspected_at
      t.datetime :graded_at
      t.integer :score
      t.text :violation_description
      t.text :violation_code
      t.text :grade

      t.timestamps null: false
    end
  end
end
