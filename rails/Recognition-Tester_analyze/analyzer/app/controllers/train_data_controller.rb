class TrainDataController < ApplicationController
  before_action :set_train_datum, only: [:show, :edit, :update, :destroy]

  # GET /train_data
  # GET /train_data.json
  def index
    @train_data = TrainDatum.all
  end

  # GET /train_data/1
  # GET /train_data/1.json
  def show
  end

  # GET /train_data/new
  def new
    @train_datum = TrainDatum.new
  end

  # GET /train_data/1/edit
  def edit
  end

  # POST /train_data
  # POST /train_data.json
  def create
    @train_datum = TrainDatum.new(train_datum_params)

    respond_to do |format|
      if @train_datum.save
        format.html { redirect_to @train_datum, notice: 'Train datum was successfully created.' }
        format.json { render :show, status: :created, location: @train_datum }
      else
        format.html { render :new }
        format.json { render json: @train_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /train_data/1
  # PATCH/PUT /train_data/1.json
  def update
    respond_to do |format|
      if @train_datum.update(train_datum_params)
        format.html { redirect_to @train_datum, notice: 'Train datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @train_datum }
      else
        format.html { render :edit }
        format.json { render json: @train_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /train_data/1
  # DELETE /train_data/1.json
  def destroy
    @train_datum.destroy
    respond_to do |format|
      format.html { redirect_to train_data_url, notice: 'Train datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_train_datum
      @train_datum = TrainDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def train_datum_params
      params.fetch(:train_datum, {})
    end
end
