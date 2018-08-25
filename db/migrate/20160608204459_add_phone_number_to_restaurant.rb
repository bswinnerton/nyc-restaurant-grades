class AddPhoneNumberToRestaurant < ActiveRecord::Migration[4.2]
  def change
    add_column :restaurants, :phone_number, :text
  end
end
