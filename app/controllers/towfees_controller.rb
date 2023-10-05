class TowfeesController < ApplicationController
  before_action :require_user
  before_action :set_towfee, only: %i[ show edit update destroy ]

  # GET /towfees or /towfees.json
  def index
    @towfees = Towfee.all
  end

  # GET /towfees/1 or /towfees/1.json
  def show
  end

  # GET /towfees/new
  def new
    @towfee = Towfee.new
  end

  # GET /towfees/1/edit
  def edit
  end

  # POST /towfees or /towfees.json
  def create
    @towfee = Towfee.new(towfee_params)

    respond_to do |format|
      if @towfee.save
        format.html { redirect_to towfees_path, notice: "Towfee was successfully created." }
        format.json { render :show, status: :created, location: @towfee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @towfee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /towfees/1 or /towfees/1.json
  def update
    respond_to do |format|
      if @towfee.update(towfee_params)
        format.html { redirect_to towfee_url(@towfee), notice: "Towfee was successfully updated." }
        format.json { render :show, status: :ok, location: @towfee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @towfee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /towfees/1 or /towfees/1.json
  def destroy
    @towfee.destroy

    respond_to do |format|
      format.html { redirect_to towfees_url, notice: "Towfee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_towfee
      @towfee = Towfee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def towfee_params
      params.require(:towfee).permit(:min_height, :max_height, :price_per)
    end

end
