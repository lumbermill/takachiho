class SettingsController < ApplicationController
  before_action :set_setting, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  # GET /settings
  # GET /settings.json
  def index
    if params[:all]
      @settings = Setting.all
    else
      @settings = current_user.settings
    end
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
    last_setting = Setting.order("raspi_id DESC").limit(1).first
    if last_setting
      @setting.raspi_id = last_setting.raspi_id + 1
    else
      @setting.raspi_id = 1
    end
    # パリティ代わりにmd5のトークン(12文字)をくっつける
    require 'digest/md5'
    @setting.token4write = Digest::MD5.new.update(@setting.raspi_id.to_s).to_s[0,12]
    @setting.user = current_user
    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: '設定が追加されました。' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
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
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/1
  # DELETE /settings/1.json
  def destroy
    @setting.destroy
    respond_to do |format|
      format.html { redirect_to settings_url, notice: 'Setting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish
    token_seed = current_user.encrypted_password + @setting.raspi_id.to_s + Time.now.to_s
    @setting.token4read = Digest::MD5.new.update(token_seed).to_s[0,12]
    @setting.updated_at = Time.now
    if @setting.save
      render text: "This Sensor data was published Successfully.", status: 200
    else
      render json: @setting.errors, status: 500
    end
  end

  def unpublish
    @setting.token4read = nil
    @setting.updated_at = Time.now
    if @setting.save
      render text: "This Sensor data was unpublished Successfully.", status: 200
    else
      render json: @setting.errors, status: 500
    end
  end

  def root

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:raspi_id, :name, :min_tmpr, :max_tmpr)
    end
end
