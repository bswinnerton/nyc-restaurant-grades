class CreateRestaurants < ActiveRecord::Migration[4.2]
  def change
    create_table :restaurants do |t|
      t.text :name
      t.text :camis
      t.text :building_number
      t.text :street
      t.text :zipcode
      t.integer :borough
      t.text :cuisine

      t.timestamps null: false
    end
  end
end
