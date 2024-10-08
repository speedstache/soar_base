class ReservationsController < ApplicationController
  before_action :require_user
  before_action :set_reservation, only: %i[show edit update destroy ]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_towpilot, only: [:tow_edit, :tow_update, :tow_index, :tow_create]


  # GET /reservations or /reservations.json
  def index
  
    @status = params[:status]

    @res_date = Reservation.search(params[:search])

    if 
      params[:search] != nil && @status.blank?
      @res_show = Day.find_by(day: params[:search]).day
      flash.now[:info] = "search date applied"
    elsif @status.blank?
      @res_show = next_flying_day 
      flash.now[:info] = "search grid set to next flying date"
    elsif
      @status.present?  
    end

    @avail_days = Day.where(day: 30.days.ago..30.days.from_now, active_flag: 1).order('days.day ASC')
    @avail_hours = Hour.where(active_flag: 1).order('hours.id ASC')
    @view_21a = @res_date.where(aircraft_id: 1)
    @view_21b = @res_date.where(aircraft_id: 2)
    @view_23 = @res_date.where(aircraft_id: 3)
    @myreservations = current_user.reservations.where(reservation_date: 20.days.ago..30.days.from_now, status: 'open').order('reservation_date DESC')
    @pastduereservations = current_user.reservations.where(reservation_date: 100.days.ago..5.days.ago, status: 'open').order('reservation_date DESC')
    @paidreservations = current_user.reservations.where(status: 'paid').order('reservation_date DESC')
    @upcomingreservations = current_user.reservations.where(reservation_date: Date.today..60.days.from_now, status: 'open').order('reservation_date DESC')
    @pendingreservations = current_user.reservations.where( status: 'pending').order('reservation_date DESC')


    if @status.blank?
      @displayreservations = @myreservations.paginate(page: params[:page], per_page: 5)
    elsif @status == 'past_due'
      @displayreservations = @pastduereservations.paginate(page: params[:page], per_page: 5)
    elsif @status == 'paid'
      @displayreservations  = @paidreservations.paginate(page: params[:page], per_page: 5)
    elsif @status == 'upcoming'
      @displayreservations = @upcomingreservations.paginate(page: params[:page], per_page: 5)
    elsif @status == 'pending'
      @displayreservations = @pendingreservations.paginate(page: params[:page], per_page: 5)
    else
      @displayreservations = @myreservations.paginate(page: params[:page], per_page: 5)
    end   
    
    @field_status = FieldStatusUpdate.where(date: @res_show).last

    if @field_status.present? && @field_status.ops_status == true
      flash.now[:success] = @field_status.title + ' - ' + @field_status.notes
    elsif @field_status.present? && @field_status.ops_status == false
      flash.now[:warning] = @field_status.title + ' - ' + @field_status.notes
    else
    end 


  end

  def club

    @res_date = Reservation.search(params[:search]).order('reservation_time ASC')

    if params[:search] != nil 
      @res_show = Day.find_by(day: params[:search]).day
      flash.now[:info] = "search date applied"
    elsif
      @res_show = next_flying_day
      flash.now[:info] = "search grid set to next flying date"
    end

    @avail_days = Day.where(day: 30.days.ago..30.days.from_now, active_flag: 1).order('days.day ASC')
    @avail_hours = Hour.where(active_flag: 1).order('hours.id ASC')
    @view_21a = @res_date.where(aircraft_id: 1)
    @view_21b = @res_date.where(aircraft_id: 2)
    @view_23 = @res_date.where(aircraft_id: 3)

    @field_status = FieldStatusUpdate.where(date: @res_show).last

    if @field_status.present? && @field_status.ops_status == true
      flash.now[:notice] = @field_status.title + ' - ' + @field_status.notes
    elsif @field_status.present? && @field_status.ops_status == false
      flash.now[:warning] = @field_status.title + ' - ' + @field_status.notes
    else
    end    

  end

  def tow_index
    require_towpilot


      @towplanes = Aircraft.where(group: 'towplane')
      @tow_schedule = Reservation.where(aircraft_id: @towplanes.ids).order('reservation_date DESC').paginate(page: params[:page], per_page: 5)

  end

  def tow_new
    
  end

  def tow_update
    require_towpilot

    @reservation = Reservation.find(params[:id])
    

    if @reservation.update(status: params[:status])

      flash[:success] = "Tow Log was successfully updated."
      redirect_to reservations_tow_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def tow_create
    
    @avail_days = Day.where(day: 30.days.ago .. 60.days.from_now)
    @avail_hours = Hour.where(active_flag: 1).first
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      ReservationMailer.confirmation(@reservation).deliver_now
      flash[:success] = "Tow schedule was successfully created."
      redirect_to params[:previous_request]
    else
      render :new, status: :unprocessable_entity
    end

  end

  def cfi_index
    require_instructor

      @instructor = Aircraft.where(group: 'instructor')
      @instructor_schedule = Reservation.where(aircraft_id: @instructor.ids).order('reservation_date DESC').paginate(page: params[:page], per_page: 5)

  end

  def cfi_new
    
  end

  def cfi_create
    
    @avail_days = Day.where(day: 30.days.ago .. 60.days.from_now)
    @avail_hours = Hour.where(active_flag: 1).first
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      ReservationMailer.confirmation(@reservation).deliver_now
      flash[:success] = "Instructor schedule was successfully created."
      redirect_to params[:previous_request]
    else
      render :new, status: :unprocessable_entity
    end

  end

  def cfi_update
    require_instructor

    @reservation = Reservation.find(params[:id])
    

    if @reservation.update(status: params[:status])

      flash[:success] = "Instructor schedule was successfully updated."
      redirect_to reservations_tow_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def comm_index
    require_commercial

      @commercial = Aircraft.where(group: 'commercial')
      @commercial_schedule = Reservation.where(aircraft_id: @commercial.ids).order('reservation_date DESC').paginate(page: params[:page], per_page: 5)

  end

  def comm_new
    
  end

  def comm_create
    
    @avail_days = Day.where(day: 30.days.ago .. 60.days.from_now)
    @avail_hours = Hour.where(active_flag: 1).first
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      ReservationMailer.confirmation(@reservation).deliver_now
      flash[:success] = "Commercial Pilot schedule was successfully created."
      redirect_to params[:previous_request]
    else
      render :new, status: :unprocessable_entity
    end

  end

  def comm_update
    require_commercial

    @reservation = Reservation.find(params[:id])
    

    if @reservation.update(status: params[:status])

      flash[:success] = "Commercial Pilot schedule was successfully updated."
      redirect_to reservations_tow_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /reservations/1 or /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])
  
  end

  # GET /reservations/new
  def new
    
    @avail_days = Day.where(day: 30.days.ago .. 30.days.from_now, active_flag: 1).order('days.day ASC')
    @avail_hours = Hour.where(active_flag: 1)
    @reservation = Reservation.new


    @date = params[:date]
    @time = params[:time]
    @aircraft = params[:aircraft]
    
  end

  # GET /reservations/1/edit
  def edit
    @avail_days = Day.where(day: 30.days.ago .. 60.days.from_now)
    @avail_hours = Hour.where(active_flag: 1)
    @towpilots = User.where(id: Permission.where(towpilot: true))
    @instructors = User.where(id: Permission.where(instructor: true))
    @commpilots = User.where(id: Permission.where(commercial: true))
  end

  # POST /reservations or /reservations.json
  def create
    @avail_days = Day.where(day: Date.today .. 60.days.from_now)
    @avail_hours = Hour.where(active_flag: 1)
    @reservation = Reservation.new(reservation_params)

    if @reservation.save
      ReservationMailer.confirmation(@reservation).deliver_now
      flash[:success] = "Reservation was successfully created."
      redirect_to params[:previous_request]
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reservations/1 or /reservations/1.json
  def update
    @avail_days = Day.where(day: 30.days.ago .. 60.days.from_now)
    @avail_hours = Hour.where(active_flag: 1)

    respond_to do |format|
      if @reservation.update(reservation_params)
          ReservationMailer.update(@reservation).deliver_now
        flash[:success] = "Reservation was successfully updated."
        format.html { redirect_to params[:previous_request] }
        format.json { render :show, status: :ok, location: reservation_path(@reservation) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1 or /reservations/1.json
  def destroy
    #must send deletion email prior to deleting reservation or it won't have the data needed to populate email
    ReservationMailer.deletion(@reservation).deliver_now
    @reservation.destroy

    respond_to do |format|
      flash[:success] = "Reservation was successfully deleted."
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:user_id, :reservation_date, :reservation_time, :reservation_duration, :aircraft_id, :instructor_flag, :rth_flag, :status, :method, :description, :previous_request)
    end

    def require_same_user
      if current_user.id != @reservation.user_id && !current_user.permission.user_admin? && !current_user.permission.instructor?
      flash[:alert] = "You can only edit or delete your own reservations"
      redirect_to @reservation
      end
    end

end
