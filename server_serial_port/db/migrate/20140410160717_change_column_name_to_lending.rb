class ChangeColumnNameToLending < ActiveRecord::Migration
	def self.up
		rename_column :lendings, :size_widht, :size_width
	end

	def self.down
		# rename back if you need or do something else or do nothing
	end
  
end