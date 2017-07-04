class TempsController < ApplicationController
  before_action :set_tmpr_log, only: [:show, :edit, :update, :destroy]
  before_action :check_auth, only: [:graph, :graph_data, :last_timestamp]
  before_action :set_access_log, only: [:graph]

  # GET /tmpr_logs
  # GET /tmpr_logs.json
  def index
    @tmpr_logs = Temp.all
  end

  # GET /tmpr_logs/1
  # GET /tmpr_logs/1.json
  def show
  end

  # GET /tmpr_logs/new
  def new
    @tmpr_log = Temp.new
  end

  # GET /tmpr_logs/1/edit
  def edit
  end

  # POST /tmpr_logs
  # POST /tmpr_logs.json
  def create
    @tmpr_log = Temp.new(tmpr_log_params)

    respond_to do |format|
      if @tmpr_log.save
        format.html { redirect_to @tmpr_log, notice: 'Tmpr log was successfully created.' }
        format.json { render :show, status: :created, location: @tmpr_log }
      else
        format.html { render :new }
        format.json { render json: @tmpr_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tmpr_logs/1
  # PATCH/PUT /tmpr_logs/1.json
  def update
    respond_to do |format|
      if @tmpr_log.update(tmpr_log_params)
        format.html { redirect_to @tmpr_log, notice: 'Tmpr log was successfully updated.' }
        format.json { render :show, status: :ok, location: @tmpr_log }
      else
        format.html { render :edit }
        format.json { render json: @tmpr_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tmpr_logs/1
  # DELETE /tmpr_logs/1.json
  def destroy
    @tmpr_log.destroy
    respond_to do |format|
      format.html { redirect_to tmpr_logs_url, notice: 'Tmpr log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def graph_data
    device_id = params[:device_id] || "1"
    src = params[:src] || "temperature"
    unit = params[:unit] || "10min"
    limit = params[:limit] || "-7 day"
    if unit == "day" # 1day
      @data = {avg: [], minmax: []}
      sql = "device_id = #{device_id} AND time_stamp > date_add(now(),interval #{limit})"
      results = TempsDaily.where(sql).order(:time_stamp)
      results.each do |row|
        ts = row["time_stamp"].to_time.to_i * 1000
        @data[:avg] += [[ts,row[src+"_average"]]]
        @data[:minmax] += [[ts,row[src+"_max"],row[src+"_min"]]]
      end
    elsif unit == "month" # 1month
        @data = {avg: [], minmax: []}
        # limit param doesn't work here.
        ym = (Date.today - 360.days).strftime("%Y%m").to_i
        sql = "device_id = #{device_id} AND `year_month` > #{ym}"
        results = TempsMonthly.where(sql).order(:year_month)
        results.each do |row|
          y = row["year_month"] / 100
          m = row["year_month"] - y * 100
          ts = Time.new(y,m,1).to_i * 1000
          @data[:avg] += [[ts,row[src+"_average"]]]
          @data[:minmax] += [[ts,row[src+"_max"],row[src+"_min"]]]
        end
    else # 10min
      @data = []
      results = Temp.where("device_id = #{device_id} AND time_stamp > date_add(now(),interval #{limit})").order(:time_stamp)
      results.each do |row|
        # @data += [["Date.parse('"+row["ts"].to_s+"')",row[src]]]
        @data += [[row.time_stamp.to_i * 1000,row.send(src)]]
      end
    end
    respond_to do |format|
      format.json { render json: @data }
    end
  end

  def graph
    @t = "{device_id: #{params[:device_id]},src: 'temperature'}"
    @p = "{device_id: #{params[:device_id]},src: 'pressure'}"
    @h = "{device_id: #{params[:device_id]},src: 'humidity'}"
    @setting = Device.find_by(device_id: params[:device_id])
    @min_tmpr = @setting.min_tmpr
    @max_tmpr = @setting.max_tmpr
    @min_timestamp = Temp.where(device_id: params[:device_id]).minimum(:time_stamp)
    @max_timestamp = Temp.where(device_id: params[:device_id]).maximum(:time_stamp)
    @token = params[:token]
    @device_id = params[:device_id]

    @n_watchers = get_access_log
  end

  # GET /temps/upload
  def upload
    device = Device.find(params[:id])
    if device.nil?
      render status:404, text: "Device not found for id="+params[:id]
      return
    elsif device.token4write != params[:token]
      render status:404, text: "Token did not match for id="+params[:id]
      return
    end

    begin
      dt = DateTime.parse(params[:dt] || params[:time_stamp])
    rescue
      dt = DateTime.now.to_s
      render status:500, text: "dt=#{dt}&temperature=12.3&pressure=23.4&humidity=34.5&illuminance=45.6&voltage=56.7"
      return
    end

    @temp = Temp.find_or_initialize_by(device_id: device.id, dt: dt)
    insert_or_update = @temp.id.nil? ? "Inserted" : "Updated"
    @temp.temperature = params[:temperature]
    @temp.pressure = params[:pressure]
    @temp.humidity = params[:humidity]
    @temp.illuminance = params[:illuminance]
    @temp.voltage = params[:voltage]
    @temp.sender = request.remote_ip

    if @temp.save
      render text: "#{insert_or_update} #{@temp.id}", status: 200
    else
      render text: @temp.errors, status: 500
    end
  end

  def last_timestamp
    device_id = params[:id]
    unit = params[:unit] || "10min"
    if unit == "day" # 1day
      @tmpr_log = TempsDaily.where(device_id: device_id).order(:time_stamp).last
    else # 10min
      @tmpr_log = Temp.where(device_id: device_id).order(:time_stamp).last
    end

    if @tmpr_log.blank?
      render text: "NO DATA", status: 200
    else
      render text: @tmpr_log.time_stamp, status: 200
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tmpr_log
      @tmpr_log = Temp.find(params[:id])
    end

    def check_auth
      if params[:token]
        session[:token4read] = params[:token]
      end
      if params[:device_id]
        session[:device_id] = params[:device_id]
      end
      setting = Device.find_by(device_id: session[:device_id])
      if session[:token4read]
        unless setting.token4read == session[:token4read]
          authenticate_user!
        end
      else
        authenticate_user!
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tmpr_log_params
      params.require(:tmpr_log).permit(:device_id, :time_stamp, :temperature, :pressure, :humidity)
    end
end
