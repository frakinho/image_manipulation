class AddColumnToLendings < ActiveRecord::Migration
  def change
    add_column :lendings, :security_value, :float
  end
end
