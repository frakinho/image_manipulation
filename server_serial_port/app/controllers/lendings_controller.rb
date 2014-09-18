class LendingsController < ApplicationController
  before_action :set_lending, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => [:init_lending,:koha_request]


  # GET /lendings
  # GET /lendings.json
  def index
    #@lendings = Lending.all.reverse
    @lendings = Lending.paginate(:page => params[:page],:order => "created_at DESC")

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
    


    if @lending.lending.nil?
      @lending_or_not = @lending.lending_calculation

      @lending.lending = @lending_or_not
      @lending.save
    else
      @lending_or_not = @lending.lending
    end
    
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

    puts "Teste_1"
    if book.nil?
      book = Book.new(:biblionumber => params["biblionumber"],:author => params["author"],:title => params["title"],:barcode => params["barcode"])
      book.save
    end
    puts "Teste_2"
    #Read weight from balance
  
    sp = ServerSerialPort::Application.config.my_app.serial_port
    puts "Teste_3"
    if sp.nil?

      json_text = {:error => 1,:found => 'not_found'}.to_json

      render :json => json_text

    else
      puts "Teste_4"
      sp.flush_input
      @read_value = sp.gets.chomp
      puts "Teste_6"
      @read_value1 = sp.gets.chomp
      puts "Teste_7"
      @read_value2 = sp.gets.chomp
      puts "Teste_8"
      sp.flush_input
      puts "Teste_9"

      system "imagesnap -d \"#{ServerSerialPort::Application.config.my_app.camera}\""

      weight = (((@read_value.to_f+@read_value1.to_f+@read_value2.to_f) / 3))
      puts "AVG: #{weight}"



      puts "Total: #{weight}"

      File.open("snapshot.jpg") do |file_image|
        @lending = Lending.new(:user_id => params["user_id"],:book_id => book.id,:weight => weight,:image => file_image)
        if @lending.book.weight.nil?
          @lending.book.weight = weight
        end
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

        puts "========>AQUI VOU ESCREVER PARA O ARDUINO COM #{@lending.lending}"
        if @lending.lending     
          
          $global_variable.write 1
        end 



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

    end

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
