$global_variable = SerialPort.new("/dev/tty.usbmodem1421", 9600, 8, 1, SerialPort::NONE)
class WelcomeController < ActionController::Base
	layout "application"
	
	before_filter :set_variable

	def index
	    @books = Book.take(21)

	end

	def reload_partial
		render :partial => "welcome/dynamic"
	end



	def refresh_header
		puts "Aqui ------"
		sp = $global_variable 
		@read_value = sp.gets.chomp
		puts @read_value
	    
		render :partial => 'welcome/dynamic', :locals => {:partil_value => @read_value}
	end

	def set_variable
  		port_str = "/dev/tty.usbmodem1421"  #may be different for you
	    baud_rate = 9600
	    data_bits = 8
	    stop_bits = 1
	    parity = SerialPort::NONE
	end
	
	def reset
		redirect_to root_path
	end

end