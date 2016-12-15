class TmprLogsController < ApplicationController
  before_action :set_tmpr_log, only: [:show, :edit, :update, :destroy]

  # GET /tmpr_logs
  # GET /tmpr_logs.json
  def index
    @tmpr_logs = TmprLog.all
  end

  # GET /tmpr_logs/1
  # GET /tmpr_logs/1.json
  def show
  end

  # GET /tmpr_logs/new
  def new
    @tmpr_log = TmprLog.new
  end

  # GET /tmpr_logs/1/edit
  def edit
  end

  # POST /tmpr_logs
  # POST /tmpr_logs.json
  def create
    @tmpr_log = TmprLog.new(tmpr_log_params)

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
    raspi_id = params[:raspi_id] || "1"
    src = params[:src] || "temperature"
    unit = params[:unit] || "10min"
    limit = params[:limit] || "-7 day"
    if unit == "day" # 1day
      @data = {avg: [], minmax: []}
      sql = "raspi_id = #{raspi_id} AND time_stamp > date_add(now(),interval #{limit})"
      results = TmprDailyLog.where(sql).order(:time_stamp)
      results.each do |row|
        ts = row["time_stamp"].to_time.to_i * 1000
        @data[:avg] += [[ts,row[src+"_average"]]]
        @data[:minmax] += [[ts,row[src+"_max"],row[src+"_min"]]]
      end
    elsif unit == "month" # 1month
        @data = {avg: [], minmax: []}
        # limit param doesn't work here.
        ym = (Date.today - 360.days).strftime("%Y%m").to_i
        sql = "raspi_id = #{raspi_id} AND `year_month` > #{ym}"
        results = TmprMonthlyLog.where(sql).order(:year_month)
        results.each do |row|
          y = row["year_month"] / 100
          m = row["year_month"] - y * 100
          ts = Time.new(y,m,1).to_i * 1000
          @data[:avg] += [[ts,row[src+"_average"]]]
          @data[:minmax] += [[ts,row[src+"_max"],row[src+"_min"]]]
        end
    else # 10min
      @data = []
      results = TmprLog.where("raspi_id = #{raspi_id} AND time_stamp > date_add(now(),interval #{limit})").order(:time_stamp)
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
    @t = "{raspi_id: #{params[:raspi_id]},src: 'temperature'}"
    @p = "{raspi_id: #{params[:raspi_id]},src: 'pressure'}"
    @h = "{raspi_id: #{params[:raspi_id]},src: 'humidity'}"
    @setting = Setting.find_by(raspi_id: params[:raspi_id],user_id: current_user.id)
    @min_tmpr = @setting.min_tmpr
    @max_tmpr = @setting.max_tmpr
    @min_timestamp = TmprLog.where(raspi_id: params[:raspi_id]).minimum(:time_stamp)
    @max_timestamp = TmprLog.where(raspi_id: params[:raspi_id]).maximum(:time_stamp)
  end

  # GET /tmpr_logs/insert
  def insert
    setting = Setting.find_by(raspi_id: params[:id])
    if setting.nil?
      render status:404, text: "Device not found for raspi_id="+params[:id]
      return
    elsif setting.token4write != params[:token]
      render status:404, text: "Token did not match for raspi_id="+params[:id]
      return
    end
    raspi_id = params[:id]
    time_stamp = DateTime.parse(params[:time_stamp])
    @tmpr_log = TmprLog.find_or_initialize_by(raspi_id: raspi_id, time_stamp: time_stamp)
    insert_or_update = @tmpr_log.id.nil? ? "Inserted" : "Updated"
    @tmpr_log.temperature = params[:temperature]
    @tmpr_log.pressure = params[:pressure]
    @tmpr_log.humidity = params[:humidity]
    @tmpr_log.sender = request.remote_ip

    if @tmpr_log.save
      render text: "#{insert_or_update} #{@tmpr_log.id}", status: 200
    else
      render text: @tmpr_log.errors, status: 500
    end
  end

  def last_timestamp
    raspi_id = params[:id]
    unit = params[:unit] || "10min"
    if unit == "day" # 1day
      @tmpr_log = TmprDailyLog.where(raspi_id: raspi_id).order(:time_stamp).last
    else # 10min
      @tmpr_log = TmprLog.where(raspi_id: raspi_id).order(:time_stamp).last
    end

    if @tmpr_log.blank?
      render text: @tmpr_log.errors, status: 500
    else
      render text: @tmpr_log.time_stamp, status: 200
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tmpr_log
      @tmpr_log = TmprLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tmpr_log_params
      params.require(:tmpr_log).permit(:raspi_id, :time_stamp, :temperature, :pressure, :humidity)
    end
end
