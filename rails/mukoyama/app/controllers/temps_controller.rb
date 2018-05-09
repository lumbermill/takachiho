class TempsController < ApplicationController
  before_action :set_temp, only: [:show, :edit, :update, :destroy]
  before_action :check_auth, only: [:graph, :graph_data, :latest]
  before_action :set_access_log, only: [:graph]

  # GET /tmpr_logs
  # GET /tmpr_logs.json
  def index
    if params[:device_id]
      @device = Device.find(params[:device_id])
      @temps = Temp.where(device_id: @device.id).order("id desc").limit(10)
      @temps_count = Temp.where(device_id: @device.id).count
      @temps_oldest = Temp.where(device_id: @device.id).order("id asc").limit(1)

      @temps_dailies = TempsDaily.where(device_id: params[:device_id]).order("id desc").limit(3)
      @temps_monthlies = TempsMonthly.where(device_id: params[:device_id]).order("id desc").limit(3)
    else
      @device = nil
      @temps = Temp.order("id desc").limit(10)
      @temps_count = Temp.count
      @temps_olders = Temp.order("id asc").limit(1)

      @temps_dailies = TempsDaily.order("id desc").limit(3)
      @temps_monthlies = TempsMonthly.order("id desc").limit(3)
    end
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
      @data = []
      sql = "device_id = #{device_id} AND d > date_add(now(),interval -30 day)" #FIXME: とりあえず30決め打ち
      results = TempsDaily.where(sql).order(:d)
      results.each do |row|
        ts = row["d"].to_time.to_i * 1000
        r = [ts]
        r += [row["temperature_average"]]
        r += [row["humidity_average"]]
        r += [row["temperature_min"]]
        r += [row["temperature_max"]]
        @data += [r]
        # @data[:avg] += [[ts,row[src+"_average"]]]
        # @data[:minmax] += [[ts,row[src+"_max"],row[src+"_min"]]]
      end
    elsif unit == "month" # 1month
      @data = []
      # limit param doesn't work here.
      ym = (Date.today - 360.days).strftime("%Y%m").to_i
      sql = "device_id = #{device_id} AND `year_month` > #{ym}"
      results = TempsMonthly.where(sql).order(:year_month)
      results.each do |row|
        y = row["year_month"] / 100
        m = row["year_month"] - y * 100
        ts = Time.new(y,m,1).to_i * 1000
        r = [ts]
        r += [row["temperature_average"]]
        r += [row["humidity_average"]]
        r += [row["temperature_min"]]
        r += [row["temperature_max"]]
        @data += [r]
      end
    else # 10min
      @data = []
      # @data += [["Timestamp","Value"]]
      results = Temp.where("device_id = #{device_id} AND dt > date_add(now(),interval #{limit})").order(:dt)
      results.each do |row|
        ts = (row.dt.to_i) * 1000 # + row.dt.utc_offset
        r = [ts]
        if src.is_a? Array
          r += [row.send(src[0])]
          r += [row.send(src[1])]
        else
          r += [row.send(src)]
        end
        @data += [r]
      end
    end
    respond_to do |format|
      format.json { render json: @data }
    end
  end

  def graph
    @t = "{device_id: #{params[:device_id]},src: ['temperature','humidity']}"
    @p = "{device_id: #{params[:device_id]},src: 'pressure'}"
    @h = "{device_id: #{params[:device_id]},src: 'humidity'}"
    @i = "{device_id: #{params[:device_id]},src: 'illuminance'}"
    @v = "{device_id: #{params[:device_id]},src: 'voltage'}"
    @device = Device.find(params[:device_id])
    @temp_min = @device.temp_min
    @temp_max = @device.temp_max
    @min_timestamp = Temp.where(device_id: params[:device_id]).minimum(:dt)
    @max_timestamp = Temp.where(device_id: params[:device_id]).maximum(:dt)
    @token = params[:token]
    @device_id = params[:device_id]

    @n_watchers = get_access_log
  end

  # GET /temps/upload
  def upload
    fnames = [:temperature, :pressure, :humidity, :illuminance, :voltage, :extra1, :extra2, :extra3]
    device = Device.find_by(id: params[:id])
    if device.nil?
      render status:404, text: "Device not found for id=#{params[:id]}"
      return
    elsif device.token4write != params[:token]
      render status:404, text: "Token did not match for id=#{params[:id]}"
      return
    end

    begin
      dt_str = params[:dt] || params[:time_stamp]
      # 「+」記号のURLエンコーディングに失敗しているケースが散見されるため救済（+はスペースになる）
      dt = DateTime.parse(dt_str.sub(" ","+"))
    rescue
      dt = DateTime.now.to_s
      render status:500, text: "dt=#{dt}&temperature=12.3&pressure=23.4&humidity=34.5&illuminance=45.6&voltage=56.7"
      return
    end

    @temp = Temp.find_or_initialize_by(device_id: device.id, dt: dt)
    insert_or_update = @temp.id.nil? ? "Inserted" : "Updated"
    fnames.each { |n| @temp[n] = params[n] }
    @temp.sender = request.remote_ip

    if @temp.save
      render text: "#{insert_or_update} #{@temp.id}", status: 200
    else
      render text: @temp.errors, status: 500
    end
  end

  # GET /temps/download
  def download
    require 'csv'
    device_id = params[:device_id]

    unless current_user.mine?(Device.find(device_id)) || current_user.admin?
      render file: 'public/403.html', status: 403, layout: 'application', content_type: 'text/html'
      return
    end

    @data = Temp.where(device_id: device_id).order("dt asc")
    logger.debug(@data)
  end

  def latest
    # 最新のレコードを返す、ようにしたいが、今のところ更新確認用にタイムスタンプのみ返します
    device_id = params[:id]
    unit = params[:unit] || "min"
    if unit == "day" # 1day
      @tmpr_log = TempsDaily.where(device_id: device_id).order("d desc").limit(1).first
    else # 10min
      @tmpr_log = Temp.where(device_id: device_id).order("dt desc").limit(1).first
    end

    if @tmpr_log.blank?
      render text: "No data found for #{device_id} #{unit}", status: 200
    else
      render text: @tmpr_log.created_at, status: 200
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_temp
      @tmpr_log = Temp.find(params[:id])
    end

    def check_auth
      id = params[:id] || params[:device_id]
      if id
        session[:device_id] = id
      end
      if params[:token]
        session[:token4read] = params[:token]
      end
      device = Device.find(session[:device_id])
      if session[:token4read]
        unless device.token4read == session[:token4read]
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
