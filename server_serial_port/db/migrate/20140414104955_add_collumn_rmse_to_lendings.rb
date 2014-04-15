class AddCollumnRmseToLendings < ActiveRecord::Migration
  def change
    add_column :lendings, :rmse, :float
  end
end
