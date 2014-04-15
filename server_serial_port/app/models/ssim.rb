class SSIM

	def initialize
		@gaussian_kernel_sigma = 1.5
		@gaussian_kernel_width = 10

		#Array bidimentional with @gaussian_kernel_width X @gaussina_kernel_width
		@gaussian_kernel = []

		(0..@gaussian_kernel_width).each do |i| 
			new_array = []
			(0..@gaussian_kernel_width).each do |j|
				new_array[j] = 0
			end
			@gaussian_kernel[i] = new_array
		end
	end

	#Fill gaussian kernel
	def fill_gaussian_kernel
		##Kernel to apply gassuian filter to image matrix
		for i in (0..@gaussian_kernel_width)
	        for j in (0..@gaussian_kernel_width)
	            @gaussian_kernel[i][j]=(1/(2*Math::PI*(@gaussian_kernel_sigma**2)))*Math.exp(-(((i-5)**2)+((j-5)**2))/(2*(@gaussian_kernel_sigma**2)))
    		end
    	end
    end

    #############
    ### READ IMAGE FILE
    ### CONVERT TO GRAYSCALE
    ### RESHAPE ARRAY TO 11x11
    #############
    def read_file_image(filename)
    	#Read File and convert to grayscale
    	img = Magick::Image::read(filename)[0]

    	img = img.resize(150, 216)

    	img = img.quantize(256, Magick::GRAYColorspace)
    	
    	#Convert to a 2D Matrix
    	pixel_array = []
    	img.each_pixel do |pixel,column,row|
    		pixel_array.push((pixel.red / 257.0))
    	end

    	#################
    	###### RESHAPE ARRAY
    	###### CREATE Window
    	pixel_array = pixel_array.each_slice(img.columns).to_a

    	return pixel_array
    end

    ###############
    ### GET array from image file
    ###############
    def get_array_from_image(img)
        pixel_array = []
        img.each_pixel do |pixel,column,row|
            #### All channel contain the same value
            pixel_array.push((pixel.red / 257.0))
        end

        pixel_array = pixel_array.each_slice(img.columns).to_a

    end


    #############
    #### PROCESSING IMAGE AND CALCULATE SSIM
    #############
    def image_processing(filename_1,filename_2)
        #img = Magick::Image::read(filename_1)[0]
        #img = img.resize(150, 216)
        #img = img.quantize(256, Magick::GRAYColorspace)

        #i2g = Magick::Image::read(filename_2)[0]
        #i2g = img.resize(150, 216)
        #i2g = img.quantize(256, Magick::GRAYColorspace)


    	pixel_array_img1 = read_file_image(filename_1)
    	pixel_array_img2 = read_file_image(filename_2)

    	pixel_array_sq_img1 = []
    	pixel_array_sq_img2 = []
    	pixel_array_img1x2 = []

    	###### ARRAY OF PIXEL ARRAY
    	# SQUARE IMAGE IMG_1
    	pixel_array_sq_img1 = square_array(pixel_array_img1)		
		pixel_array_sq_img2 = square_array(pixel_array_img2)
    	pixel_array_img1x2  = product_array(pixel_array_img1,pixel_array_img2)

		# Apply convolve filter two image array
		img_1_convolve_filter = convolve(pixel_array_img1,@gaussian_kernel)
		img_2_convolve_filter = convolve(pixel_array_img2,@gaussian_kernel)

		## Array Square
		img_1_convolve_filter_sq = square_array(img_1_convolve_filter)
		img_2_convolve_filter_sq = square_array(img_2_convolve_filter)
		img_2x1_convolve_filter  = product_array(img_1_convolve_filter,img_2_convolve_filter)


		#Convolve FILTER Square IMG1 and IMG2
		img_1_sq_convolve_filter = convolve(pixel_array_sq_img1,@gaussian_kernel)
		img_2_sq_convolve_filter = convolve(pixel_array_sq_img2,@gaussian_kernel)


		#Convolve FILTER to Product IMG1 and IMG2 
		img_1x2_convolve_filter  = convolve(pixel_array_img1x2,@gaussian_kernel)

		img_1_sq_convolve_filter = difference_array(img_1_sq_convolve_filter,img_1_convolve_filter_sq)
		img_2_sq_convolve_filter = difference_array(img_2_sq_convolve_filter,img_2_convolve_filter_sq)
		img_1x2_convolve_filter  = difference_array(img_1x2_convolve_filter,img_2x1_convolve_filter)



		#c1/c2 constants
	    #First use: manual fitting
	    c_1=6.5025
	    c_2=58.5225
	    
	    #Second use: change k1,k2 & c1,c2 depend on L (width of color map)
	    l=255
	    k_1=0.01
	    c_1=(k_1*l)**2
	    k_2=0.03
	    c_2=(k_2*l)**2
	    
	    #Numerator of SSIM
	    num_ssim = product_array(multiple_and_factor_increment(2,img_2x1_convolve_filter,c_1),multiple_and_factor_increment(2,img_1x2_convolve_filter,c_2))
	    ##Denominator of SSIM
	    den_ssim = product_array(sum_two_array_and_incremente(img_1_convolve_filter_sq,img_2_convolve_filter_sq,c_1),sum_two_array_and_incremente(img_1_sq_convolve_filter,img_2_sq_convolve_filter,c_2))
	    ##SSIM
	    index = division_and_average(num_ssim,den_ssim)

	    puts index

        return index

    end

    def time_diff_milli(start, finish)
	   (finish - start) * 1000.0
	end

    #CONVOLVE ALGORITM
    def convolve(pixel_array_img,kernel)
    	kCenterX = @gaussian_kernel_width / 2
		kCenterY = @gaussian_kernel_width / 2
		rows = pixel_array_img.size - 1
		cols = pixel_array_img[0].size - 1

		out_pixel = []

		t1 = Time.now

		(0..(rows+1)).each do |i|
			out_pixel[i] = Array.new((cols+1),0)
		end

		t2 = Time.now
		msecs = time_diff_milli t1, t2
		puts msecs

		#Copy Image to new array
		out_pixel_array_img = pixel_array_img.map(&:dup)

		t3 = Time.now
		msecs = time_diff_milli t2, t3
		puts msecs

		(0..rows).each do |i| 				# rows
		    (0..cols).each do |j|           # columns
		        (0..@gaussian_kernel_width).each do |m|     # kernel rows
		            mm = @gaussian_kernel_width - 1 - m     # row index of flipped kernel
		            (0..@gaussian_kernel_width).each do |n| # kernel columns
		                nn = @gaussian_kernel_width - 1 - n  # column index of flipped kernel
		                # index of input signal, used for checking boundary
		                ii = i + (m - kCenterY)
		                jj = j + (n - kCenterX)

		                #puts "i: #{i} j: #{j} mm: #{mm} nn: #{nn} ii: #{ii} jj: #{jj}"
		                # ignore input samples which are out of bound
		                if (ii >= 0) && (ii < rows) && (jj >= 0) && (jj < cols)
		                	out_pixel[i][j] = out_pixel[i][j] + pixel_array_img[ii][jj] * kernel[mm][nn]
		            	end
		            end
		        end
		    end
		end

		t4 = Time.now
		msecs = time_diff_milli t3, t4
		puts "--------------#{msecs}"

		##Return image with apply filter
		return out_pixel
    end

    ### Apply square function in all elements of array
    ### pixel_array_img is a array of arrays 
    def square_array(pixel_array_img)
    	pixel_array_sq_img = []
    	pixel_array_img.each_with_index do |array_pixel,i|
    		new_array = []
    		array_pixel.each_with_index do |number,j|
    			new_array[j] = number*number
    		end
    		pixel_array_sq_img[i] = new_array
    	end

    	return pixel_array_sq_img
    end

    # NEW ARRAY WITH IMG1 x IMG2
    ### Product of two Array
    def product_array(pixel_array_1,pixel_array_2)
    	pixel_array_sq_img1x2 = []
    	pixel_array_1.each_with_index do |array_pixel,i|
    		new_array = []
    		array_pixel.each_with_index do |number,j|
    			new_array[j] = pixel_array_1[i][j] * pixel_array_2[i][j]
    			#pixel_array_sq_img1x2[i][j] = 
    		end
    		pixel_array_sq_img1x2[i] = new_array
    	end

    	return pixel_array_sq_img1x2
    end

    def difference_array(img_array_1,img_array_2)
    	img_array_1.each_with_index do |array_pixel,i|
    		array_pixel.each_with_index do |number,j|
    			img_array_1[i][j] = number - img_array_2[i][j]
    		end
    	end

    	return img_array_1
    end

    def multiple_and_factor_increment(factor_x,array_img,increment_plus)
    	array_img.each_with_index do |array_pixel,i|
    		array_pixel.each_with_index do |number,j|
    			array_img[i][j] = number*factor_x+increment_plus
    		end
    	end
    	return array_img
    end

    def sum_two_array_and_incremente(array_img_1,array_img_2,increment)
    	array_img_1.each_with_index do |array_pixel,i|
    		array_pixel.each_with_index do |number,j|
    			array_img_1[i][j] = array_img_1[i][j] + array_img_2[i][j] + increment
    		end
    	end
    	return array_img_1
    end

    #Calculate division about all element present in two arrays and calculate de average of all elementes
    def division_and_average(array_1,array_2)
    	avg = 0
    	total_element = 0
    	array_1.each_with_index do |array_pixel,i|
    		array_pixel.each_with_index do |number,j|
    			array_1[i][j] = number / array_2[i][j]
    			avg = avg + array_1[i][j] 
    			total_element = total_element + 1
    		end
    	end
    	return (avg / total_element)
    end

end