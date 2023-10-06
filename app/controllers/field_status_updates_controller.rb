class FieldStatusUpdatesController < ApplicationController
  before_action :set_field_status_update, only: %i[ show edit update destroy ]
  before_action :require_user

  # GET /field_status_updates or /field_status_updates.json
  def index
    @field_status_updates = FieldStatusUpdate.all
  end

  # GET /field_status_updates/1 or /field_status_updates/1.json
  def show
  end

  # GET /field_status_updates/new
  def new
    @field_status_update = FieldStatusUpdate.new
  end

  # GET /field_status_updates/1/edit
  def edit
  end

  # POST /field_status_updates or /field_status_updates.json
  def create
    @field_status_update = FieldStatusUpdate.new(field_status_update_params)

    respond_to do |format|
      if @field_status_update.save

        FieldStatusMailer.field_status(@field_status_update).deliver_now
        format.html { redirect_to field_status_update_url(@field_status_update), notice: "Field status update was created and sent." }
        format.json { render :show, status: :created, location: @field_status_update }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @field_status_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /field_status_updates/1 or /field_status_updates/1.json
  def update
    respond_to do |format|
      if @field_status_update.update(field_status_update_params)
        format.html { redirect_to field_status_update_url(@field_status_update), notice: "Field status update was successfully updated." }
        format.json { render :show, status: :ok, location: @field_status_update }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @field_status_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_status_updates/1 or /field_status_updates/1.json
  def destroy
    @field_status_update.destroy

    respond_to do |format|
      format.html { redirect_to field_status_updates_url, notice: "Field status update was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field_status_update
      @field_status_update = FieldStatusUpdate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def field_status_update_params
      params.require(:field_status_update).permit(:username, :date, :ops_status, :title, :notes)
    end

end
