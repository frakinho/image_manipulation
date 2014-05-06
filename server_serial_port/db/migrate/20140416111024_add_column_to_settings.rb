class AddColumnToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :min_value, :float
  end
end
