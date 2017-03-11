class CreateViolations < ActiveRecord::Migration
  def change
    create_table :violations do |t|
      t.text :description
      t.text :code
      t.integer :inspection_id

      t.timestamps null: false
    end
  end
end
