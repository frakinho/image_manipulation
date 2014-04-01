class ImageController < ApplicationController
  
  def load

  	#file_name = "file:///home/frakinho/image_manipulation/server_serial_port/app/assets/images/coisa.jpg"

    img = Magick::Image::read("file:///home/plima/image_manipulation/image_manipulation/server_serial_port/app/assets/images/#{params[:image]}").first


    puts "   Format: #{img.format}"
    puts "   Geometry: #{img.columns}x#{img.rows}"
    puts "   Class: " + case img.class_type
                            when Magick::DirectClass
                                "DirectClass"
                            when Magick::PseudoClass
                                "PseudoClass"
                        end
    puts "   Depth: #{img.depth} bits-per-pixel"

    @img_view = img

    #a = img.blur_image(radius=1.0, sigma=2.0)

    a = img.median_filter(radius=3)


    a.display

    b = a.median_filter(radius=3)

    b.display

    c = b.edge(radius=2)

    c.display

    c.image_type = Magick::BilevelType

    c.display

    d = c.median_filter(radius=3)

    d.display

    #d.display
    #img.image_type = Magick::BilevelType
    #c = img.median_filter(radius=8)
    #d = c.edge(radius=0)
    #d.display
    #c = b.median_filter(radius=8)
    #d = c.edge(radius=2)
    
    pix = d.pixel_color(451,220)

    puts "Red:#{(pix.red)} - Blue:#{(pix.blue)} - Green:#{(pix.green)}"

    top    = Point.new(0,d.rows)
    bottom = Point.new(0,0)
    left   = Point.new(d.columns,0)
    right  = Point.new(0,0)


    ##FIND TOP_LEFT
    d.each_pixel do |pixel, col, row|
      
      if pixel.red == 65535 && pixel.green == 65535 && pixel.blue == 65535
        if row < top.y
          top.x = col
          top.y = row
        end
        if row > bottom.y
          bottom.x = col
          bottom.y = row
        end
        if col < left.x
          left.x = col
          left.y = row
        end
        if col > right.x
          right.x = col
          right.y = row
        end
      end 
    end

    ###########################################
    ########### ANGLE #########################
    ###########################################
    m0 = 1.0 / 2.0
    m1 = ((left.y.to_f   - top.y)   / (top.x    - left.x)) ##TOP => LEFT
    m2 = ((right.y.to_f  - top.y)   / (right.x  - top.x)) ##RIGHT => TOP
    m3 = ((bottom.y.to_f - left.y)  / (bottom.x - left.x))  ##BOTTOM => LEFT
    m4 = ((bottom.y.to_f - right.y) / (right.x  - bottom.x)) ##BOTTOM => RIGHT

    puts "M0: #{m0}"
    puts "M1: #{m1.to_f}"
    puts "M2: #{m2.to_f}"
    puts "M3: #{m3}"
    puts "M4: #{m4}"

    ang_TOP =    Math.atan(((m1 - m2) / (1 + m1 * m2)).abs)
    ang_RIGHT =  Math.atan(((m2 - m4) / (1 + m2 * m4)).abs)
    ang_BOTTOM = Math.atan(((m4 - m3) / (1 + m4 * m3)).abs)
    ang_LEFT =   Math.atan(((m3 - m1) / (1 + m3 * m1)).abs)

    #ang_TOP = Math.atan2((left.y - top.y),(top.x - left.x))
    #ang_RIGHT = Math.atan2((right.y - top.y),(right.x - top.x))
    #ang_BOTTOM = Math.atan2((bottom.y - left.y),(bottom.x - left.x))
    #ang_LEFT = Math.atan2((bottom.y - right.y),(right.x - bottom.x))

    puts "ANGGGGGG"
    puts "TOP #{((ang_TOP    * 180) / Math::PI)}"
    puts "LEF #{((ang_RIGHT  * 180) / Math::PI)}"
    puts "BOT #{((ang_BOTTOM * 180) / Math::PI)}"
    puts "RIG #{((ang_LEFT   * 180) / Math::PI)}"

    bound = d.bounding_box
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

    #Value top in CM
    value_top_cm = ((bound.width) * 21.5) / 237
    #Value of height
    value_height_cm = ((bound.height) * 21.5) / 237

    gc_1.text(bound.x+(bound.width/2),bound.y-15,"#{value_top_cm}")
    gc_1.text(bound.x - 15,(bound.height / 2),"#{value_height_cm}")

    gc_1.text(bound.x+bound.width-15, bound.y-5, "\'#{bound.x+bound.width},#{bound.y}\'")
    gc_1.text(bound.x-15, bound.y+bound.height+15, "\'#{bound.x},#{bound.y+bound.height}\'")
    gc_1.text(bound.x+bound.width-15, bound.y+bound.height+15, "\'#{bound.x+bound.width},#{bound.y+bound.height}\'")
    
    gc_1.draw(d)

    gc = Magick::Draw.new
    gc.stroke("blue")
    gc.fill_opacity(0)
    gc.polygon(top.x, top.y, left.x, left.y,bottom.x,bottom.y,right.x,right.y)
    gc.fill("white")
    gc.stroke("transparent")

    gc.text(top.x-15, top.y-5, "\'TOP:#{top.x},#{top.y}\'")
    gc.text(left.x-5, left.y-5, "\'Left#{left.x},#{left.y}\'")
    gc.text(right.x-15, right.y-15, "\'Right#{right.x},#{right.y}\'")
    gc.text(bottom.x, bottom.y, "\'Bottom#{bottom.x},#{bottom.y}\'")

    gc.draw(d)

    d.pixel_color(bottom.x,bottom.y ,"red")
    d.pixel_color(left.x  ,left.y   ,"red")
    d.pixel_color(right.x ,right.y  ,"red")

    puts top
    puts bottom
    puts left
    puts right  

    #d.display

    gc_1.draw(img)
    img.display


    #b = img.quantize(number_colors=256, colorspace=Magick::GRAYColorspace, dither=true, tree_depth=0, measure_error=false)
    #a.image_type = Magick::BilevelType

    #a.display

    #b = img.median_filter(radius=8.0)

    #b.display

    #c = b.reduce_noise(radius=10)

    #c.display

    #d = b.edge(radius=0.1)

    #bound = d.bounding_box
    

  	#gc = Magick::Draw.new
    #gc.stroke("gray50")
    #gc.fill_opacity(0)
    #gc.rectangle(bound.x, bound.y, bound.x+bound.width, bound.y+bound.height)
    #gc.stroke("red")
  	#gc.circle(bound.x, bound.y, bound.x+2, bound.y+2)
  	#gc.circle(bound.x+bound.width, bound.y, bound.x+bound.width+2, bound.y+2)
  	#gc.circle(bound.x, bound.y+bound.height, bound.x+2, bound.y+bound.height+2)
  	#gc.circle(bound.x+bound.width, bound.y+bound.height, bound.x+bound.width+2, bound.y+bound.height+2)

  	#gc.fill("white")
  	#gc.stroke("transparent")
  	#gc.text(bound.x-15, bound.y-5, "\'#{bound.x},#{bound.y}\'")
  	#gc.text(bound.x+bound.width-15, bound.y-5, "\'#{bound.x+bound.width},#{bound.y}\'")
  	#gc.text(bound.x-15, bound.y+bound.height+15, "\'#{bound.x},#{bound.y+bound.height}\'")
  	#gc.text(bound.x+bound.width-15, bound.y+bound.height+15, "\'#{bound.x+bound.width},#{bound.y+bound.height}\'")


  	#gc.draw(d)
    #d.display

    #d.write("final_book.jpg")

    #coisa = @img_view.blur_image(radius=20.0, sigma=1.0)

    #coisa.display
  end

  def save
  end

  def index
    @images = Dir.glob("app/assets/images/*.jpg")
  end

  def manipulation
    img = Magick::Image::read("file:///home/plima/image_manipulation/image_manipulation/server_serial_port/app/assets/images/me_test.jpg").first
    img2 = Magick::Image::read("file:///home/plima/image_manipulation/image_manipulation/server_serial_port/app/assets/images/no_me_test.jpg").first
    
    img = img.resize_to_fit(350, 460)
    img2 = img.resize_to_fit(350, 460)
asdsda
    #a = img.auto_gamma_channel
    #a.display
    #b = img2.auto_gamma_channel
    #b.display
    #img = a
    #img2 = b

    img = img.quantize(256, Magick::GRAYColorspace)
    img2 = img2.quantize(256, Magick::GRAYColorspace)

    img.display
    img2.display

    img.each_pixel do |pixel, col, row|
      
      pixel_img2 = img2.pixel_color(col,row)

      red   = pixel.red - pixel_img2.red 
      green = pixel.green - pixel_img2.green
      blue  = pixel.blue - pixel_img2.blue

      if red < 0 
        red = 0
      end

      if green < 0
        green = 0 
      end

      if blue < 0
        blue = 0 
      end


      a = Pixel.new(red, green, blue, pixel.opacity)
      img.pixel_color(col,row,a)


    end

    img.display
  end


  def live

  end


  def compare

    @img_filename = params[:compare][0]
    @img2_filename = params[:compare][1]

    img = Magick::Image::read("/home/plima/image_manipulation/image_manipulation/server_serial_port/app/assets/images/#{@img_filename}").first
    i2g = Magick::Image::read("/home/plima/image_manipulation/image_manipulation/server_serial_port/app/assets/images/#{@img2_filename}").first

    img = img.resize(350, 460)
    i2g = i2g.resize(350, 460)

    img.display
    i2g.display


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




    #First image
    a.each do |pixel|
      #red
      value_convert_8bit = pixel[0].red / 257
      value_red = value_convert_8bit - (value_convert_8bit % 10) 

      #green
      value_convert_8bit_green = pixel[0].green / 257
      value_green = value_convert_8bit_green - (value_convert_8bit_green % 10) 

      #blue
      value_convert_8bit_blue = pixel[0].blue / 257
      value_blue = value_convert_8bit_blue - (value_convert_8bit_blue % 10)  

      #Add value to array
      list_red_channel_first_img[value_red] = list_red_channel_first_img[value_red] + pixel[1]
      list_blue_channel_first_img[value_blue] = list_red_channel_first_img[value_blue] + pixel[1]
      list_green_channel_first_img[value_green] = list_red_channel_first_img[value_green] + pixel[1]

    end

    #Second image
    b.each do |pixel|
      #red
      value_convert_8bit = pixel[0].red / 257
      value_red = value_convert_8bit - (value_convert_8bit % 10) 

      #green
      value_convert_8bit_green = pixel[0].green / 257
      value_green = value_convert_8bit_green - (value_convert_8bit_green % 10) 

      #blue
      value_convert_8bit_blue = pixel[0].blue / 257
      value_blue = value_convert_8bit_blue - (value_convert_8bit_blue % 10)  

      #Add value to array
      list_red_channel_second_img[value_red] = list_red_channel_second_img[value_red] + pixel[1]
      list_blue_channel_second_img[value_blue] = list_red_channel_second_img[value_blue] + pixel[1]
      list_green_channel_second_img[value_green] = list_red_channel_second_img[value_green] + pixel[1]
      
    end


    first_line = ""
    
    #Variable to write in file
    st_write_red_channel_first_img = ""
    st_write_blue_channel_first_img = ""
    st_write_green_channel_first_img = ""
    
    st_write_red_channel_second_img = ""
    st_write_blue_channel_second_img = ""
    st_write_green_channel_second_img = ""


    @dif_red_channel = 0
    @dif_blue_channel = 0
    @dif_green_channel = 0

    File.open('/home/plima/Desktop/fix.csv', 'w') do |f1|  

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

      #Second IMAGE
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



    ## Calculate diference
    dif = 0
    teste.each do |valor|
      if !testeb[valor[0]].nil?
        dif = dif + (testeb[valor[0]] - valor[1]).abs
      else 
        dif = dif + valor[0]
      end
    end 

    dif

  end
end
