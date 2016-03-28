class TmprDailyLogsController < ApplicationController
  before_action :set_tmpr_daily_log, only: [:show, :edit, :update, :destroy]

  # GET /tmpr_daily_logs
  # GET /tmpr_daily_logs.json
  def index
    @tmpr_daily_logs = TmprDailyLog.all
  end

  # GET /tmpr_daily_logs/1
  # GET /tmpr_daily_logs/1.json
  def show
  end

  # GET /tmpr_daily_logs/new
  def new
    @tmpr_daily_log = TmprDailyLog.new
  end

  # GET /tmpr_daily_logs/1/edit
  def edit
  end

  # POST /tmpr_daily_logs
  # POST /tmpr_daily_logs.json
  def create
    @tmpr_daily_log = TmprDailyLog.new(tmpr_daily_log_params)

    respond_to do |format|
      if @tmpr_daily_log.save
        format.html { redirect_to @tmpr_daily_log, notice: 'Tmpr daily log was successfully created.' }
        format.json { render :show, status: :created, location: @tmpr_daily_log }
      else
        format.html { render :new }
        format.json { render json: @tmpr_daily_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tmpr_daily_logs/1
  # PATCH/PUT /tmpr_daily_logs/1.json
  def update
    respond_to do |format|
      if @tmpr_daily_log.update(tmpr_daily_log_params)
        format.html { redirect_to @tmpr_daily_log, notice: 'Tmpr daily log was successfully updated.' }
        format.json { render :show, status: :ok, location: @tmpr_daily_log }
      else
        format.html { render :edit }
        format.json { render json: @tmpr_daily_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tmpr_daily_logs/1
  # DELETE /tmpr_daily_logs/1.json
  def destroy
    @tmpr_daily_log.destroy
    respond_to do |format|
      format.html { redirect_to tmpr_daily_logs_url, notice: 'Tmpr daily log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tmpr_daily_log
      @tmpr_daily_log = TmprDailyLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tmpr_daily_log_params
      params.require(:tmpr_daily_log).permit(:raspi_id, :time_stamp, :temperature, :pressure, :humidity)
    end
end
