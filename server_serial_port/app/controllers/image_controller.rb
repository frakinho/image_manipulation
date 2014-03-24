class ImageController < ApplicationController
  
  def load

  	file_name = "file:///home/frakinho/image_manipulation/server_serial_port/app/assets/images/coisa.jpg"

    img = Magick::Image::read("file:///Users/frakinho/Documents/Arduino/rails_server/server_serial_port/app/assets/images/book1.jpg").first
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

    a = img.gaussian_blur(radius=2.0, sigma=5.0)
    
    #a.display
    #b = img.quantize(number_colors=256, colorspace=Magick::GRAYColorspace, dither=true, tree_depth=0, measure_error=false)
    a.image_type = Magick::BilevelType

    a.display

    b = img.median_filter(radius=8.0)

    b.display

    #c = b.reduce_noise(radius=10)

    #c.display

    d = b.edge(radius=0.1)

    bound = d.bounding_box
    

	gc = Magick::Draw.new
	gc.stroke("gray50")
	gc.fill_opacity(0)
	gc.rectangle(bound.x, bound.y, bound.x+bound.width, bound.y+bound.height)
	gc.stroke("red")
	gc.circle(bound.x, bound.y, bound.x+2, bound.y+2)
	gc.circle(bound.x+bound.width, bound.y, bound.x+bound.width+2, bound.y+2)
	gc.circle(bound.x, bound.y+bound.height, bound.x+2, bound.y+bound.height+2)
	gc.circle(bound.x+bound.width, bound.y+bound.height, bound.x+bound.width+2, bound.y+bound.height+2)

	gc.fill("white")
	gc.stroke("transparent")
	gc.text(bound.x-15, bound.y-5, "\'#{bound.x},#{bound.y}\'")
	gc.text(bound.x+bound.width-15, bound.y-5, "\'#{bound.x+bound.width},#{bound.y}\'")
	gc.text(bound.x-15, bound.y+bound.height+15, "\'#{bound.x},#{bound.y+bound.height}\'")
	gc.text(bound.x+bound.width-15, bound.y+bound.height+15, "\'#{bound.x+bound.width},#{bound.y+bound.height}\'")


	gc.draw(d)
    d.display

    d.write("final_book.jpg")

    #coisa = @img_view.blur_image(radius=20.0, sigma=1.0)

    #coisa.display
  end

  def save
  end

  def manipulation
  end
end
