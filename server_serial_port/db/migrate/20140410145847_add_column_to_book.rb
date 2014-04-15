class AddColumnToBook < ActiveRecord::Migration
  def change
    add_column :books, :size_width, :float
    add_column :books, :size_height, :float
  end
end
