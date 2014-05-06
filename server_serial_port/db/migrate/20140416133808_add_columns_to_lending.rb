class AddColumnsToLending < ActiveRecord::Migration
  def change
    add_column :lendings, :lending, :boolean 
    add_column :lendings, :setting_id, :integer
    add_column :lendings, :weight_error, :float
    add_column :lendings, :size_error, :float
  end
end
