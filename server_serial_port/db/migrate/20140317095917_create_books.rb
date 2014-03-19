class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :barcode
      t.float :weight
      t.string :title

      t.timestamps
    end
  end
end
