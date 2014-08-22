class Book < ActiveRecord::Base
	has_many :lendings
	searchkick

	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => ":style/no_image.png"	
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]


	def field_verify(image,x,y)
		puts "AQUIIIIIIIIIIIIIIIIIIIIIIIIIIII #{self.image_file_name}"
		if self.image_file_name.nil?
			puts "AQUIIIIIIIIIIIIIIIIIIIIIIIIIIII1"
			self.image = self.image = File.new(image)
			self.size_width = x
			self.size_height = y
			self.save

			return -1
		else
			##All value is present in database 
			puts "AQUIIIIIIIIIIIIIIIIIIIIIIIIIIII2"

			return 0
		end
		puts "AQUIIIIIIIIIIIIIIIIIIIIIIIIIIII3"
	end
	
end
