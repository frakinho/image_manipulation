class AddImageToLending < ActiveRecord::Migration
	def self.up
		add_attachment :lendings, :image
	end

	def self.down
		remove_attachment :lendings, :image
	end
  
end
