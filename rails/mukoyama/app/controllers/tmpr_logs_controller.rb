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
    if unit == "day" # 1day
      @data = {avg: [], max: [], min: [], diff: []}
      sql = "SELECT ts,#{src}_avg,#{src}_max,#{src}_min FROM bme280_logs_dailies WHERE raspi_id = #{id} ORDER BY ts"
      results = db.query(sql)
      results.each do |row|
        ts = (row["ts"].to_time.to_i + 9 * 60 * 60) * 1000
        @data[:avg] += [[ts,row[src+"_avg"]]]
        @data[:max] += [[ts,row[src+"_max"]]]
        @data[:min] += [[ts,row[src+"_min"]]]
        @data[:diff] += [[ts,row[src+"_max"] - row[src+"_min"]]]
      end
    else # 10min
      @data = []
      results = TmprLog.all().order(:time_stamp)
      results.each do |row|
        # @data += [["Date.parse('"+row["ts"].to_s+"')",row[src]]]
        @data += [[(row.time_stamp.to_i + 9 * 60 * 60) * 1000,row.send(src)]]
      end
    end
    respond_to do |format|
      format.json { render json: @data }
    end
  end

  def graph
    @p = "{}"
    setting = Setting.find_by(raspi_id: 1)
    @min_tmpr = setting.min_tmpr
    @max_tmpr = setting.max_tmpr
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
