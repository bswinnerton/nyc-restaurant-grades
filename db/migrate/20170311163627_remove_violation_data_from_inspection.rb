class RemoveViolationDataFromInspection < ActiveRecord::Migration
  def change
    remove_column :inspections, :violation_code, :text
    remove_column :inspections, :violation_description, :text
  end
end
