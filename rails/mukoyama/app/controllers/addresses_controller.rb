class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  # GET /addresses
  # GET /addresses.json
  def index
    setting = Setting.find_by(raspi_id: params[:raspi_id],user_id: current_user.id)
    raise 'Setting not found for current user.' unless setting
    @addresses = setting.addresses
    @raspi_id = params[:raspi_id]
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @raspi_id = params[:raspi_id]
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
    @raspi_id = @address.raspi_id
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
    raspi_id = @address.raspi_id
    @address.destroy
    respond_to do |format|
      format.html { redirect_to addresses_url(raspi_id: raspi_id), notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_testmail
    mail = params[:mail]
    # res = Mailer.test_send.deliver_now
    res = Mailer.send_mail(mail, "mukoyama", "メール送信テストです。").deliver_now
    render text: res, status: 200
  end

  def send_testcall
    phone = params[:phone]
    res = Mailer.make_call(phone, "テストです")
    render text: res, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:raspi_id, :mail, :snooze, :active)
    end
end
