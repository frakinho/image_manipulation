class AddCollumnToBook < ActiveRecord::Migration
  def change
    add_column :books, :biblionumber, :integer
    add_column :books, :author, :string
  end
end
