class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy]
  before_filter do
    authenticate_patron! rescue redirect_to new_patron_session_path
  end

  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.all
    #IF the system platform is MAC OS X
    if ServerSerialPort::Application.config.PLATFORM == 2
      value = `imagesnap -l`
      @cameras = value.split("\n")
    end

    @camera = "/dev/video0"
    
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @setting = Setting.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Setting was successfully created.' }
        format.json { render action: 'show', status: :created, location: @setting }
      else
        format.html { render action: 'new' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /change_camera?camera=NAME
  def change_camera
    puts params
    camera = params["camera"]

    puts "CAMERA: #{camera}"

    ServerSerialPort::Application.config.my_app.camera = camera
    if ServerSerialPort::Application.config.my_app.camera.nil?
      json_text = {:success => 'false'}.to_json
    else
      json_text = {:success => 'true'}.to_json
    end

    render :json => json_text

  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:debug, :security_level, :size, :similarity, :weight,:description,:in_use,:min_value)
    end
end
