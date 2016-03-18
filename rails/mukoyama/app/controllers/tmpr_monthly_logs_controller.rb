class TmprMonthlyLogsController < ApplicationController
  before_action :set_tmpr_monthly_log, only: [:show, :edit, :update, :destroy]

  # GET /tmpr_monthly_logs
  # GET /tmpr_monthly_logs.json
  def index
    @tmpr_monthly_logs = TmprMonthlyLog.all
  end

  # GET /tmpr_monthly_logs/1
  # GET /tmpr_monthly_logs/1.json
  def show
  end

  # GET /tmpr_monthly_logs/new
  def new
    @tmpr_monthly_log = TmprMonthlyLog.new
  end

  # GET /tmpr_monthly_logs/1/edit
  def edit
  end

  # POST /tmpr_monthly_logs
  # POST /tmpr_monthly_logs.json
  def create
    @tmpr_monthly_log = TmprMonthlyLog.new(tmpr_monthly_log_params)

    respond_to do |format|
      if @tmpr_monthly_log.save
        format.html { redirect_to @tmpr_monthly_log, notice: 'Tmpr monthly log was successfully created.' }
        format.json { render :show, status: :created, location: @tmpr_monthly_log }
      else
        format.html { render :new }
        format.json { render json: @tmpr_monthly_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tmpr_monthly_logs/1
  # PATCH/PUT /tmpr_monthly_logs/1.json
  def update
    respond_to do |format|
      if @tmpr_monthly_log.update(tmpr_monthly_log_params)
        format.html { redirect_to @tmpr_monthly_log, notice: 'Tmpr monthly log was successfully updated.' }
        format.json { render :show, status: :ok, location: @tmpr_monthly_log }
      else
        format.html { render :edit }
        format.json { render json: @tmpr_monthly_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tmpr_monthly_logs/1
  # DELETE /tmpr_monthly_logs/1.json
  def destroy
    @tmpr_monthly_log.destroy
    respond_to do |format|
      format.html { redirect_to tmpr_monthly_logs_url, notice: 'Tmpr monthly log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tmpr_monthly_log
      @tmpr_monthly_log = TmprMonthlyLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tmpr_monthly_log_params
      params.require(:tmpr_monthly_log).permit(:raspi_id, :year_month, :temperature, :pressure, :humidity)
    end
end
