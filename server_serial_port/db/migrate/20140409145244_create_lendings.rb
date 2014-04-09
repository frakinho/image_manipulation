class CreateLendings < ActiveRecord::Migration
  def change
    create_table :lendings do |t|
      t.integer :user_id
      t.integer :book_id
      t.float :size_widht
      t.float :size_height
      t.float :weight

      t.timestamps
    end
  end
end
