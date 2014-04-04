class SSIM
	require 'rubygems'
	require 'rmagick'

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

		@img = "filename"
		@i2g = "filename_2" 
	end

	def img
		return @img
	end

	#Fill gaussian kernel
	def fill_gaussian_kernel

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


    #############
    #### PROCESSING IMAGE AND CALCULATE SSIM
    #############
    def image_processing
    	pixel_array_img1 = read_file_image("image.jpg")
    	pixel_array_img2 = read_file_image("file.jpg")


    	pixel_array_sq_img1 = []
    	pixel_array_sq_img2 = []
    	pixel_array_sq_img1x2 = []
    	##################FALTA AQUI ALGO

    	###### ARRAY OF PIXEL ARRAY
    	# IMG_1
    	pixel_array_img1.each_with_index do |array_pixel,i|
    		new_array = []
    		array_pixel.each_with_index do |number,j|
    			new_array[j] = number*number
    			#pixel_array_sq_img1[i][j] = number*number
    			puts pixel_array_img1[i][j]
    		end
    		pixel_array_sq_img1[i] = new_array
    	end

    	# IMG_2
    	pixel_array_img2.each_with_index do |array_pixel,i|
    		new_array = []
    		array_pixel.each_with_index do |number,j|
    			new_array[j] = number*number
       			#pixel_array_sq_img2[i][j] = number * number
    		end
    		pixel_array_sq_img2[i] = new_array
    	end

    	# NEW ARRAY WITH IMG1 x IMG2
    	pixel_array_sq_img1.each_with_index do |array_pixel,i|
    		new_array = []
    		array_pixel.each_with_index do |number,j|
    			new_array[j] = pixel_array_sq_img1[i][j] * pixel_array_sq_img2[i][j]
    			#pixel_array_sq_img1x2[i][j] = 
    		end
    		pixel_array_sq_img1x2[i] = new_array
    	end

    	puts "Size:"
    	puts pixel_array_img1.size
    	puts pixel_array_img1[0].size

		# NEED CONVOLVE FILTER
		#

		convolve(pixel_array_img1,@gaussian_kernel)

    end

    #CONVOLVE ALGORITM
    def convolve(pixel_array_img,kernel)
    	kCenterX = 5
		kCenterY = 5
		rows = pixel_array_img.size
		cols = pixel_array_img[0].size

		out_pixel_array_img = pixel_array_img


		(0..rows).each do |i| 				# rows
		    (0..cols).each do |j|           # columns
		        sum = 0                     # init to 0 before sum
		        (0..@gaussian_kernel_width).each do |m|     # kernel rows
		            mm = @gaussian_kernel_width - 1 - m     # row index of flipped kernel
		            (0..@gaussian_kernel_width).each do |n| # kernel columns
		                nn = @gaussian_kernel_width - 1 - n  # column index of flipped kernel
		                # index of input signal, used for checking boundary
		                ii = i + (m - kCenterY)
		                jj = j + (n - kCenterX)
		                puts "rows: #{i} - cols: #{j}"
		                # ignore input samples which are out of bound
		                if (ii >= 0) && (ii < rows) && (jj >= 0) && (jj < cols)
		                	pixel_array_img[i][j] = out_pixel_array_img[ii][jj] * kernel[mm][nn]
		                	#out_pixel_array_img [i][j] = out_pixel_array_img [i][j] + pixel_array_img[ii][jj] * kernel[mm][nn]
		            	end
		            end
		        end
		    end
		end
    end



	def i2g
		return @i2g
	end

	def get_gaussian_kernel
		i = 0
		@gaussian_kernel.each do |valor|
			i = i + 1
		end

		return @gaussian_kernel
	end

end


instance = SSIM.new
instance.get_gaussian_kernel
instance.fill_gaussian_kernel
instance.image_processing
#instance.image_processing
#instance.get_gaussian_kernel


