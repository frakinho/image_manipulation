class AddCollumnUseToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :in_use, :boolean
  end
end
