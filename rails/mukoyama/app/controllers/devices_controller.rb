class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy, :publish, :unpublish, :picture]

  # GET /settings
  # GET /settings.json
  def index
    if params[:all]
      @devices = Device.all
    else
      @devices = current_user.devices
    end
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
  end

  # GET /settings/new
  def new
    @device = Device.new
  end

  # GET /settings/1/edit
  def edit
  end

  # POST /settings
  # POST /settings.json
  def create
    @device = Device.new(device_params)
    # パリティ代わりにmd5のトークン(12文字)をくっつける
    require 'digest/md5'
    @device.token4write = Digest::MD5.new.update(rand.to_s).to_s[0,12]
    @device.user = current_user
    respond_to do |format|
      if @device.save
        format.html { redirect_to @device, notice: '設定が追加されました。' }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        # tokenが空なら削除
        format.html { redirect_to @device, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish
    token_seed = current_user.encrypted_password + @device.device_id.to_s + Time.now.to_s
    @device.token4read = Digest::MD5.new.update(token_seed).to_s[0,12]
    @device.updated_at = Time.now
    if @device.save
      render text: "This Sensor data was published Successfully.", status: 200
    else
      render json: @device.errors, status: 500
    end
  end

  def unpublish
    @device.token4read = nil
    @device.updated_at = Time.now
    if @device.save
      render text: "This Sensor data was unpublished Successfully.", status: 200
    else
      render json: @device.errors, status: 500
    end
  end

  def picture
    if @device.picture
      response.headers['Content-Length'] = @device.picture.length
      send_data(@device.picture, type: 'image/jpeg', disposition: "inline")
    else
      send_file(Rails.root.join('app', 'assets', 'images', 'no-photo.png'), type: 'image/jpeg', disposition: "inline")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      p = params.require(:device).permit(:device_id, :name, :temp_min, :temp_max, :city_id, :picture)
      if p[:picture]
        i = Magick::Image.from_blob(p[:picture].read)[0]
        i = i.resize_to_fill(640,480)
        i.format = 'JPEG'
        p[:picture] = i.to_blob
      end
      return p
    end
end
