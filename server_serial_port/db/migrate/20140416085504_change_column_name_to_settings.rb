class ChangeColumnNameToSettings < ActiveRecord::Migration
  def self.up
    rename_column :settings, :size_height, :size
    rename_column :settings, :size_width, :similarity
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end
