class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :debug
      t.float :security_level
      t.float :size_height
      t.float :size_width
      t.float :weight

      t.timestamps
    end
  end
end
