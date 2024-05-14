class AircraftsController < ApplicationController
  before_action :require_user
  before_action :set_aircraft, only: %i[ show edit update destroy ]
  before_action :require_club_admin

  # GET /aircrafts or /aircrafts.json
  def index
    @aircrafts = Aircraft.where.not(group: 'instructor').paginate(page: params[:page], per_page: 10).order('aircrafts.id ASC')
    @aircrafts = Aircraft.where.not(group: 'commercial').paginate(page: params[:page], per_page: 10).order('aircrafts.id ASC')

    
  end

  # GET /aircrafts/1 or /aircrafts/1.json
  def show

    if @aircraft.group != 'towplane'
      if Flight.where(aircraft_id: @aircraft).blank?
        @flighthours = 0
        @flightcount = 0
      else
        @sumhours = Flight.where(aircraft_id: @aircraft, flight_date: @aircraft.last_maintenance..Date.today )
        @flightcount = @sumhours.count
        @flighthours = (@sumhours.sum(:flight_time)/60+@sumhours.sum(:flight_time)%60/60.to_f)
      end
    else    
      if Tow.where(aircraft_id: @aircraft.id).blank? 
        @last_maintenance_tow_date = Date.today
        @most_recent_tow_date = Date.today
        @sumtows = 0
        @sumtowhours = 0
      elsif Tow.order('tows.tow_date ASC').where(tow_date: ..@aircraft.last_maintenance).last.blank?
        @last_maintenance_tow_date = Tow.order('tows.tow_date ASC').where(tow_date: ..Date.today).first
        @most_recent_tow_date = Tow.order('tows.tow_date ASC').where(tow_date: ..Date.today).last
        @sumtows = Tow.where(aircraft_id: @aircraft, tow_date: @aircraft.last_maintenance..Date.today ).sum(:tows)
        @sumtowhours = @most_recent_tow_date.tach_end - @last_maintenance_tow_date.tach_start
      else  
        @sumtows = Tow.where(aircraft_id: @aircraft, tow_date: @aircraft.last_maintenance..Date.today ).sum(:tows)
        @last_maintenance_tow_date = Tow.order('tows.tow_date ASC').where(tow_date: ..@aircraft.last_maintenance).last
        @most_recent_tow_date = Tow.order('tows.tow_date ASC').where(tow_date: ..Date.today).last
        @sumtowhours = @most_recent_tow_date.tach_end - @last_maintenance_tow_date.tach_end
      end  
    end  

  end

  # GET /aircrafts/new
  def new
    @aircraft = Aircraft.new
  end

  # GET /aircrafts/1/edit
  def edit
  end

  # POST /aircrafts or /aircrafts.json
  def create
    @aircraft = Aircraft.new(params.require(:aircraft).permit(:name, :short_name, :group, :last_maintenance, :active_flag))

    respond_to do |format|
      if @aircraft.save
        format.html { redirect_to aircraft_url(@aircraft), notice: "Aircraft was successfully created." }
        format.json { render :show, status: :created, location: @aircraft }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @aircraft.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /aircrafts/1 or /aircrafts/1.json
  def update
    respond_to do |format|
      if @aircraft.update(params.require(:aircraft).permit(:name, :short_name, :group, :last_maintenance, :active_flag))
        format.html { redirect_to aircrafts_path, notice: "Aircraft was successfully updated." }
        format.json { render :show, status: :ok, location: @aircraft }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @aircraft.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /aircrafts/1 or /aircrafts/1.json
  def destroy
    @aircraft.destroy

    respond_to do |format|
      format.html { redirect_to aircrafts_url, notice: "Aircraft was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_aircraft
      @aircraft = Aircraft.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def aircraft_params
      params.fetch(:aircraft, {})
    end



end
