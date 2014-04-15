class AddCollumnToLendings < ActiveRecord::Migration
  def change
    add_column :lendings, :ssim, :float
  end
end
