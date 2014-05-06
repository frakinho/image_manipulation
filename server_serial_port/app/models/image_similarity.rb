class Image_Similarity


	def read_image_from_webcam
		return "file:///home/frakinho/image_manipulation/server_serial_port/app/assets/images/teste.jpg"
	end

	def image_resize(img)
		img = img.resize(150,216)

		return img
	end

	########
	# Histogram color diference
	def hist_color_diference
		#Read_from web_cam
		@img_filename = "book2 no_table_invert.jpg"
		#Book in database
		@img2_filename = "book2 no_table.jpg"
		
		img = Magick::Image::read("/home/frakinho/image_manipulation/server_serial_port/app/assets/images/#{@img_filename}").first
		i2g = Magick::Image::read("/home/frakinho/image_manipulation/server_serial_port/app/assets/images/#{@img2_filename}").first
		img = image_resize(img)
		i2g = image_resize(i2g)
		img = img.auto_level_channel
		i2g = i2g.auto_level_channel
		img = img.despeckle
		i2g = i2g.despeckle
		img = img.auto_gamma_channel(LuminosityChannel)
		i2g = i2g.auto_gamma_channel(LuminosityChannel)
		img = img.median_filter(radius=10)
		i2g = i2g.median_filter(radius=10)
	    img = img.quantize(number_colors=256)
	    i2g = i2g.quantize(number_colors=256)



	    img = img.set_channel_depth(AllChannels,8)
	    a = img.color_histogram
	    b = i2g.color_histogram

	    teste   = {}
	    testeb  = {}
	    
	    # Dif between two images, the diference is based on diference between the red, blue and green channel 
	    list_red_channel_first_img = {}
	    list_blue_channel_first_img = {}
	    list_green_channel_first_img = {}

	    list_red_channel_second_img = {}
	    list_blue_channel_second_img = {}
	    list_green_channel_second_img = {}

	    #Init array
	    i = 0
	    while i < 260
	      list_red_channel_first_img[i] = 0
	      list_blue_channel_first_img[i] = 0
	      list_green_channel_first_img[i] = 0

	      list_red_channel_second_img[i] = 0
	      list_blue_channel_second_img[i] = 0
	      list_green_channel_second_img[i] = 0
	      #teste[i] = 0
	      #testeb[i] = 0

	      i = i + 10
	    end 

	    #This factor is necessary because Imagemagick is compile in differente version 8bit 16bit ... 
		correct_factor = 257

	    #First image
	    a.each do |pixel|
	      #red
	      value_convert_8bit = pixel[0].red / correct_factor
	      value_red = value_convert_8bit - (value_convert_8bit % 10) 

	      #green
	      value_convert_8bit_green = pixel[0].green / correct_factor
	      value_green = value_convert_8bit_green - (value_convert_8bit_green % 10) 

	      #blue
	      value_convert_8bit_blue = pixel[0].blue / correct_factor
	      value_blue = value_convert_8bit_blue - (value_convert_8bit_blue % 10)  

	      #Add value to array
	      list_red_channel_first_img[value_red] = list_red_channel_first_img[value_red] + pixel[1]
	      list_blue_channel_first_img[value_blue] = list_red_channel_first_img[value_blue] + pixel[1]
	      list_green_channel_first_img[value_green] = list_red_channel_first_img[value_green] + pixel[1]

	    end

	    #Second image
	    b.each do |pixel|
	      #red
	      value_convert_8bit = pixel[0].red / correct_factor
	      value_red = value_convert_8bit - (value_convert_8bit % 10) 

	      #green
	      value_convert_8bit_green = pixel[0].green / correct_factor
	      value_green = value_convert_8bit_green - (value_convert_8bit_green % 10) 

	      #blue
	      value_convert_8bit_blue = pixel[0].blue / correct_factor
	      value_blue = value_convert_8bit_blue - (value_convert_8bit_blue % 10)  

	      #Add value to array
	      list_red_channel_second_img[value_red] = list_red_channel_second_img[value_red] + pixel[1]
	      list_blue_channel_second_img[value_blue] = list_red_channel_second_img[value_blue] + pixel[1]
	      list_green_channel_second_img[value_green] = list_red_channel_second_img[value_green] + pixel[1]
	      
	    end

	    dif_red_channel = 0
	    dif_blue_channel = 0
	    dif_green_channel = 0

	    # Calculate diference in all channel
	    list_red_channel_first_img.each do |value|
			dif_red_channel = dif_red_channel + (value[1] - list_red_channel_second_img[value[0]]).abs
		end
			
		#BLUE
		list_blue_channel_first_img.each do |value|
			dif_blue_channel = dif_blue_channel + (value[1] - list_blue_channel_second_img[value[0]]).abs
		end
		#GREEN
		list_green_channel_first_img.each do |value|
			dif_green_channel = dif_green_channel + (value[1] - list_green_channel_second_img[value[0]]).abs
		end

		# Debug MOD
		if ServerSerialPort::Application.config.my_app.debug
		    first_line = ""
	    
		    #Variable to write in file
		    st_write_red_channel_first_img = ""
		    st_write_blue_channel_first_img = ""
		    st_write_green_channel_first_img = ""
		    
		    st_write_red_channel_second_img = ""
		    st_write_blue_channel_second_img = ""
		    st_write_green_channel_second_img = ""

		    File.open('/log/fix.csv', 'w') do |f1|  

		      #write array two csv file, for analyse in a spreadsheet
		      #First IMAGE
		      #RED
		      list_red_channel_first_img.each do |value|
		        first_line = first_line + "#{value[0]},"
		        st_write_red_channel_first_img = st_write_red_channel_first_img + "#{value[1]},"

		        @dif_red_channel = @dif_red_channel + (value[1] - list_red_channel_second_img[value[0]]).abs
		      end
		      #BLUE
		      list_blue_channel_first_img.each do |value|
		        st_write_blue_channel_first_img = st_write_blue_channel_first_img + "#{value[1]},"

		        @dif_blue_channel = @dif_blue_channel + (value[1] - list_blue_channel_second_img[value[0]]).abs
		      end
		      #GREEN
		      list_green_channel_first_img.each do |value|
		        st_write_green_channel_first_img = st_write_green_channel_first_img + "#{value[1]},"
		      
		        @dif_green_channel = @dif_green_channel + (value[1] - list_green_channel_second_img[value[0]]).abs
		      end

		      #Write Second IMAGE to file
		      list_red_channel_second_img.each do |value|
		        st_write_red_channel_second_img = st_write_red_channel_second_img + "#{value[1]},"
		      end
		      
		      list_blue_channel_second_img.each do |value|
		        st_write_blue_channel_second_img = st_write_blue_channel_second_img + "#{value[1]},"
		      end
		      
		      list_green_channel_second_img.each do |value|
		        st_write_green_channel_second_img = st_write_green_channel_second_img + "#{value[1]},"
		      end

		      f1.puts first_line

		      f1.puts st_write_red_channel_first_img
		      f1.puts st_write_blue_channel_first_img
		      f1.puts st_write_green_channel_first_img

		      f1.puts "\n"

		      f1.puts st_write_red_channel_second_img
		      f1.puts st_write_blue_channel_second_img
		      f1.puts st_write_green_channel_second_img
		    end 
		end 
	end
	
	########
	# Calculate size of book
	def size_calculation(file_name)
		#file_name = "file:///home/frakinho/image_manipulation/server_serial_port/app/assets/images/coisa.jpg"
	    original = Magick::Image::read(file_name).first
		
		path_debug = get_path_without_image_name(file_name)
	    

	    #Copy for debug mod
	    image = original

	    #Apply Fitler twice for remove a max of noise 
	    image = image.median_filter(radius=3)
	    image = image.median_filter(radius=3)
	   	image.write("#{path_debug}first_filter.jpg")
	    image = image.edge(radius=2)
	   	image.write("#{path_debug}edge.jpg")

	    image.image_type = Magick::BilevelType
	    image.write("#{path_debug}BileveType.jpg")
	    image = image.median_filter(radius=1)
	    image.write("#{path_debug}last_filter.jpg")

	   	# Get Bounding_box
		bound = image.bounding_box

		#Calculate value in CM
	    #Value top in CM
	    # 237 is a variable value, depend the distance between table and camera
	    value_width_cm = ((bound.width) * 21) / 380.0
	    #Value of height
	    value_height_cm = ((bound.height) * 21) / 380.0


	    # Debug MOD 
		if ServerSerialPort::Application.config.my_app.debug
		    gc_1 = Magick::Draw.new
		    gc_1.stroke("gray50")
		    gc_1.fill_opacity(0)
		    gc_1.rectangle(bound.x, bound.y, bound.x+bound.width, bound.y+bound.height)
		    gc_1.stroke("red")
		    gc_1.circle(bound.x, bound.y, bound.x+2, bound.y+2)
		    gc_1.circle(bound.x+bound.width, bound.y, bound.x+bound.width+2, bound.y+2)
		    gc_1.circle(bound.x, bound.y+bound.height, bound.x+2, bound.y+bound.height+2)
		    gc_1.circle(bound.x+bound.width, bound.y+bound.height, bound.x+bound.width+2, bound.y+bound.height+2)
		    gc_1.fill("white")
		    gc_1.stroke("transparent")
		    gc_1.text(bound.x-15, bound.y-5, "\'#{bound.x},#{bound.y}\'")
		    gc_1.text(bound.x+(bound.width/2),bound.y-15,"#{value_width_cm}")
		    gc_1.text(bound.x - 15,(bound.height / 2),"#{value_height_cm}")
		    gc_1.text(bound.x+bound.width-15, bound.y-5, "\'#{bound.x+bound.width},#{bound.y}\'")
		    gc_1.text(bound.x-15, bound.y+bound.height+15, "\'#{bound.x},#{bound.y+bound.height}\'")
		    gc_1.text(bound.x+bound.width-15, bound.y+bound.height+15, "\'#{bound.x+bound.width},#{bound.y+bound.height}\'")	    
		    gc_1.draw(original)
		    original.write("#{path_debug}bounding.jpg")
		
		end
		image_crop = original.crop(bound.x, bound.y, bound.width, bound.height)
		image_crop = image_crop.rotate(90)
	
		image_crop.write("#{path_debug}image_crop.jpg")



	    return value_width_cm,value_height_cm
	end


	########
	## ROOT MEAN SQUARED ERROR
	def RMSE(img_filename_1,img_filename_2)



		img_1 = Magick::Image::read(img_filename_1).first
		img_2 = Magick::Image::read(img_filename_2).first

		img_1 = img_1.quantize(number_colors=256, colorspace=RGBColorspace, dither=RiemersmaDitherMethod, tree_depth=0, measure_error=true)
		img_2 = img_2.quantize(number_colors=256, colorspace=RGBColorspace, dither=RiemersmaDitherMethod, tree_depth=0, measure_error=true)

		img_1 = image_resize(img_1)
	    img_2 = image_resize(img_2)
	    
	    img_1 = img_1.auto_gamma_channel(AllChannels)
	    img_2 = img_2.auto_gamma_channel(AllChannels)

	    puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

	    puts "1: #{img_1.mean_error_per_pixel} 2: #{img_1.normalized_mean_error} 3: #{img_1.normalized_maximum_error}"

	   	array = img_1.difference(img_2)

	    puts "1: #{img_1.mean_error_per_pixel} 2: #{img_1.normalized_mean_error} 3: #{img_1.normalized_maximum_error}"

	    puts " #{array[0]}"
	    puts " #{array[1]}"
	    puts " #{array[2]}"

	    #1 is the same image - 0 is totaly differente
	    return (1 - (array[0] / 30509.92))

	    #sum_red   = 0
	    #sum_green = 0
	    #sum_blue  = 0
	    #img_max_red   = 0
	    #img_min_red   = 2**img_1.depth
	    #img_max_green = 0
	    #img_min_green = 2**img_1.depth
	    #img_max_blue  = 0
	    #img_min_blue  = 2**img_1.depth
	    #img_1.each_pixel do |pixel,column,row|
	      
	      #sum_red   = sum_red   + (((img_1.pixel_color(column,row).red   - img_2.pixel_color(column,row).red  )**2))
	      #img_max_red = change_max_value(img_max_red,img_1.pixel_color(column,row).red)
	      #img_min_red = change_min_value(img_min_red,img_1.pixel_color(column,row).red)
	      #img_max_red = change_max_value(img_max_red,img_2.pixel_color(column,row).red)
	      #img_min_red = change_min_value(img_min_red,img_2.pixel_color(column,row).red)


	      #sum_green = sum_green + (((img_1.pixel_color(column,row).green - img_2.pixel_color(column,row).green)**2))
	      ##Image 1
	      #img_max_green = change_max_value(img_max_green,img_1.pixel_color(column,row).green)
	      #img_min_green = change_min_value(img_min_green,img_1.pixel_color(column,row).green)
	      ##Ima 2 find max and min value in both 
	      #img_max_green = change_max_value(img_max_green,img_2.pixel_color(column,row).green)
	      #img_min_green = change_min_value(img_min_green,img_2.pixel_color(column,row).green)


	      #sum_blue  = sum_blue  + (((img_1.pixel_color(column,row).blue  - img_2.pixel_color(column,row).blue )**2))
	      #img_max_blue = change_max_value(img_max_blue,img_1.pixel_color(column,row).blue)
	      #img_min_blue = change_min_value(img_min_blue,img_1.pixel_color(column,row).blue)
	      #img_max_blue = change_max_value(img_max_blue,img_2.pixel_color(column,row).blue)
	      #img_min_blue = change_min_value(img_min_blue,img_2.pixel_color(column,row).blue)

	    #end
    
    	#value = (Math.sqrt(sum_red) / (img_max_red - img_min_red)) + (Math.sqrt(sum_green) / (img_max_green - img_min_green)) + (Math.sqrt(sum_blue) / (img_max_blue - img_min_blue))    

		#return value 
	end

	def change_max_value(old_value,value_to_compare)
		if old_value < value_to_compare
			return value_to_compare
		else 
			return old_value
		end
	end


	def change_min_value(old_value,value_to_compare)
		if old_value > value_to_compare
			return value_to_compare
		else 
			return old_value
		end
	end


	##########
	## Structural Similarity Index Metric 
	def ssim_processing(image_file_path,book_original_image)
		instance = SSIM.new
		#Get folder where crop image it is saved
		folder_path = get_path_without_image_name(image_file_path)

		instance.fill_gaussian_kernel
		index = instance.image_processing("#{folder_path}image_crop.jpg",book_original_image)
		return index
	end


	#########
	## AUX FUNCTION
	def get_path_without_image_name(path)
		new_path = path.split("/")
		string_path = ""
		size_withou_filename = new_path.size - 2
		(0..size_withou_filename).each do |i|
			string_path = string_path + "#{new_path[i]}/"
		end

		return string_path

	end

end