class Lending < ActiveRecord::Base

	has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
	
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

	belongs_to :book
	belongs_to :setting

	def calculate_error_size

		book = self.book
		if self.size_width.nil? || self.size_height.nil? || book.size_width.nil? || book.size_height.nil?
			return -1
		else
			width_perc = ((self.size_width - book.size_width).abs * 100) / book.size_width
			height_perc = ((self.size_height - book.size_height).abs * 100) / book.size_height
			return (100 - ((width_perc + height_perc)/2))
		end
		
	end

	def calculate_error_weight
		book = self.book

		if self.weight.nil? || book.weight.nil? 
			return -1
		else
			weight_perc = ((self.weight - book.weight).abs * 100) / book.weight
			return (100 - weight_perc)
		end

	end

	###############
	######## LENDING OR NOT LENDING
	def lending_calculation
		setting = Setting.where(:in_use => true)[0]

		##
		weight_error = calculate_error_weight / 100
		size_error   = calculate_error_size   / 100
		
		self.setting_id = setting.id
		self.weight_error = weight_error
		self.size_error   = size_error

		if weight_error < setting.min_value || size_error < setting.min_value || self.rmse < setting.min_value
			return false
		end


		size   = size_error * setting.size
		weight = weight_error *  setting.weight
		rmse   = self.rmse * setting.similarity

		total = size + weight + rmse
 
		if total < setting.security_level
			return false
		else
			return true
		end  

	end

	def get_path_without_image_name
		new_path = self.image.path.split("/")
		string_path = ""
		size_withou_filename = new_path.size - 2
		(0..size_withou_filename).each do |i|
			string_path = string_path + "#{new_path[i]}/"
		end

		return string_path

	end

	def get_path_crop_image
		return "#{get_path_without_image_name}image_crop.jpg"
	end


end
