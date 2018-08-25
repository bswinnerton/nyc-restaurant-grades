class RemoveViolationDataFromInspection < ActiveRecord::Migration[4.2]
  def change
    remove_column :inspections, :violation_code, :text
    remove_column :inspections, :violation_description, :text
  end
end
