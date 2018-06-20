class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  # GET /addresses
  # GET /addresses.json
  def index
    if params[:device_id].nil? && current_user.admin?
      @addresses = Address.all.order("id")
      @device_id = 0
      return
    end
    device = Device.find(params[:device_id])
    unless current_user.admin?
      # 他のユーザにメールアドレスを見られるのを防ぐ
      raise 'The device is not yours.' if device.user_id != current_user.id
    end
    @addresses = device.addresses
    @device_id = params[:device_id]
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @device_id = params[:device_id]
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
    @device_id = @address.device_id
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = Address.new(address_params)

    respond_to do |format|
      if @address.save
        format.html { redirect_to @address, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    device_id = @address.device_id
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url(device_id: device_id), notice: '通知先を削除しました。' }
      format.json { head :no_content }
    end
  end

  def send_message
    address = Address.find(params[:id])
    logger.debug "TO: "+address.address
    view_context.send_message([address],"メール送信テストです。")
    render text: "OK", status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:device_id, :address, :snooze, :active, :type)
    end
end
