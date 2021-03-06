require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'RMagick'
include Magick

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)



module ServerSerialPort
  class Application < Rails::Application
    config.assets.paths << "#{Rails}/vendor/assets/fonts"

    # Add variable to DEBUG 
    config.my_app = ActiveSupport::OrderedOptions.new

    begin
      $global_variable = SerialPort.new("/dev/tty.usbmodem1421", 9600, 8, 1, SerialPort::NONE)
      puts "\n\n\n\n\n\n\n ****************************************** AQUI **************************\n\n\n\n\n\n\n"
    rescue => e
      begin 
        $global_variable = SerialPort.new("/dev/tty.usbmodem1411", 9600, 8, 1, SerialPort::NONE)
      rescue => fl
        puts "\n\n\n\n\n\n\n ****************************************** ERRROR **************************\n\n\n\n\n\n\n"
      end
    end

    config.my_app.serial_port = $global_variable

    if RUBY_PLATFORM.include? "linux"
        puts "Linux Operating SYSTEM"
        config.PLATFORM = 1
        config.my_app.camera = "/dev/video0"
    elsif RUBY_PLATFORM.include? "darwin"
        puts "MAC OS"
        config.PLATFORM = 2
        value = `imagesnap -l`

        array = value.split("\n")
        camera = array.last

        config.my_app.camera = camera
        puts "final: #{array.last}"

    else
        
    end

    puts RUBY_PLATFORM    

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
