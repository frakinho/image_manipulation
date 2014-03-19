class AddWeightTrueToBook < ActiveRecord::Migration
  def change
    add_column :books, :other_weight, :float
  end
end
