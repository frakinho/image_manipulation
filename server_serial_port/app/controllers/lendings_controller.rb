class LendingsController < ApplicationController
  before_action :set_lending, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:init_lending,:koha_request]


  # GET /lendings
  # GET /lendings.json
  def index
    @lendings = Lending.all.reverse
  end

  # GET /lendings/1
  # GET /lendings/1.json
  def show
  end

  # GET /lendings/new
  def new
    @lending = Lending.new
  end

  # GET /lendings/1/edit
  def edit
    @size_perc = @lending.calculate_error_size
    @weight_perc = @lending.calculate_error_weight
    

    @lending_or_not = @lending.lending_calculation

    @lending.lending = @lending_or_not
    @lending.save
  end

  # POST /lendings
  # POST /lendings.json
  def create
    @lending = Lending.new(lending_params)

    respond_to do |format|
      if @lending.save
        format.html { redirect_to @lending, notice: 'Lending was successfully created.' }
        format.json { render action: 'show', status: :created, location: @lending }
      else
        format.html { render action: 'new' }
        format.json { render json: @lending.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /save image
  def init_lending
    data = JSON.parse(params[:tags])
    @lending = Lending.new(:book_id => data['book_id'],:weight => data['weight'],:image => params[:image])    
    data_book_id_and_weight = JSON.parse(params[:tags])

    respond_to do |format|
      if @lending.save
        book = @lending.book
        a = Image_Similarity.new
        y,x = a.size_calculation(@lending.image.path)

        ## Verify if book contains image
        @lending.security_value = book.field_verify(@lending.get_path_crop_image,x,y)        
        ###
        # GET size of image
        @lending.size_width = x
        @lending.size_height = y

        #@lending.ssim = a.ssim_processing(@lending.image.path,@lending.book.image.path)
        @lending.rmse = a.RMSE(@lending.get_path_crop_image,@lending.book.image.path)

        #@lending.rmse = a.RMSE(@lending.book.image.path,@lending.book.image.path)
        #@lending.rmse = a.RMSE("file:///Users/frakinho/Documents/Arduino/rails_server/server_serial_port/dest.jpg","file:///Users/frakinho/Documents/Arduino/rails_server/server_serial_port/neg.jpg")
        @lending.save

        #format.html { render action: 'new' }
        format.json { render json: @lending }

        
        #format.html { redirect_to @bending, notice: 'Book was successfully created.' }
        #format.json { render action: 'show', status: :created, location: @bending }
      else
        format.html { render action: 'new' }
        format.json { render json: "Teste", status: :unprocessable_entity }
      end
    end
  
  end

  #POST METHOD FROM KOHA
  def koha_request

    puts "========> #{params["barcode"]}"
    book = Book.where(barcode: params["barcode"])[0]
    
    puts "coisa => #{book}"
    if book.nil?
      book = Book.new(:biblionumber => params["biblionumber"],:author => params["author"],:title => params["title"],:barcode => params["barcode"])
      book.save
      puts "ENTREIIIII =>>>>>"
      #json_text = {:name => 'nome',:age => 23,:sucess => 'sucesso',:lending => 0}.to_json
      #render :json => json_text
      #json_text = {:name => 'nome',:age => 23,:sucess => 'insucesso',:lending => 1}.to_json
      #render :json => json_text
    end

    #Read weight from balance
    
    begin
      $global_variable = SerialPort.new("/dev/tty.usbmodem1421", 9600, 8, 1, SerialPort::NONE)
    rescue => e
      $global_variable = SerialPort.new("/dev/tty.usbmodem1411", 9600, 8, 1, SerialPort::NONE)
    end

    sp = $global_variable 
    bol = sp.flush_input
    @read_value = sp.gets.chomp
    puts "Valor: => #{@read_value}"
    bol = sp.flush_input
    puts "Valor do FLUSH => #{bol}"
    @read_value1 = sp.gets.chomp
    puts "Valor: => #{@read_value1}"
    bol = sp.flush_input
    @read_value2 = sp.gets.chomp
    puts "Valor: => #{@read_value2}"
    bol = sp.flush_input
    sp.close

    var_system = "imagesnap -d #{ServerSerialPort::Application.config.my_app.camera}"

    puts "Executei este: #{var_system}"
    system "imagesnap -d \"#{ServerSerialPort::Application.config.my_app.camera}\""
    File.open("snapshot.jpg") do |file_image|
      @lending = Lending.new(:user_id => params["user_id"],:book_id => book.id,:weight => ((@read_value.to_f+@read_value1.to_f+@read_value2.to_f) / 4),:image => file_image)
    end #file gets closed automatically here

    if @lending.save
      book = @lending.book
      a = Image_Similarity.new
      y,x = a.size_calculation(@lending.image.path)

      ## Verify if book contains image
      @lending.security_value = book.field_verify(@lending.get_path_crop_image,x,y)        
      ###
      # GET size of image
      @lending.size_width = x
      @lending.size_height = y

      #@lending.ssim = a.ssim_processing(@lending.image.path,@lending.book.image.path)
      @lending.rmse = a.RMSE(@lending.get_path_crop_image,@lending.book.image.path)

      #@lending.rmse = a.RMSE(@lending.book.image.path,@lending.book.image.path)
      #@lending.rmse = a.RMSE("file:///Users/frakinho/Documents/Arduino/rails_server/server_serial_port/dest.jpg","file:///Users/frakinho/Documents/Arduino/rails_server/server_serial_port/neg.jpg")
      @lending.save

      #@size_perc = @lending.calculate_error_size
      #@weight_perc = @lending.calculate_error_weight
      @lending_or_not = @lending.lending_calculation
      @lending.lending = @lending_or_not
      @lending.save


      #format.html { render action: 'new' }
      #format.json { render json: @lending }

      if @lending_or_not
        json_text = {:name => 'nome',:age => 23,:sucess => 'sucesso',:lending => 1}.to_json
      else
        json_text = {:name => 'nome',:rmse => 23,:sucess => 'sucesso',:lending => 0}.to_json
      end
      render :json => @lending

      
      #format.html { redirect_to @bending, notice: 'Book was successfully created.' }
      #format.json { render action: 'show', status: :created, location: @bending }
    else
      format.html { render action: 'new' }
      format.json { render json: "Teste", status: :unprocessable_entity }
    end
    





































    #puts "========> #{params["barcode"]}"
    #find_book = Book.where(barcode: params["barcode"])[0]
    #puts "coisa => #{find_book}"
    #if find_book.nil?
    #  book = Book.new(:biblionumber => params["biblionumber"],:author => params["author"],:title => params["title"],:barcode => params["barcode"])
    #  book.save
    #  puts "ENTREIIIII =>>>>>"
    #  json_text = {:name => 'nome',:age => 23,:sucess => 'sucesso',:lending => 0}.to_json
    #  render :json => json_text
    #else
    #  json_text = {:name => 'nome',:age => 23,:sucess => 'insucesso',:lending => 1}.to_json
    #  render :json => json_text
    #end
  end

  # PATCH/PUT /lendings/1
  # PATCH/PUT /lendings/1.json
  def update
    respond_to do |format|
      if @lending.update(lending_params)
        format.html { redirect_to @lending, notice: 'Lending was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @lending.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lendings/1
  # DELETE /lendings/1.json
  def destroy
    @lending.destroy
    respond_to do |format|
      format.html { redirect_to lendings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lending
      @lending = Lending.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lending_params
      params.require(:lending).permit(:user_id, :book_id, :size_width, :size_height, :weight,:image)
    end
end
