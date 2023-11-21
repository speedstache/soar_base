class DaysController < ApplicationController
  before_action :require_user
  before_action :require_site_admin

  def new
    @day = Day.new
  end
  
  def index
    @days = Day.where(day: 30.days.ago..90.days.from_now).order('days.day DESC')
  end

  def show
    @day = Day.find(params[:id])
  end

  def edit
    @day = Day.find(params[:id])
  end

  def update
    @day = Day.find(params[:id])
    respond_to do |format|
      if @day.update(day_params)
        flash[:success] = "day was successfully updated."
        format.html { redirect_to days_path }
        format.json { render :show, status: :ok, location: @day }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @day.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @day = Day.new(day_params)
    if @day.save
      flash[:success] = "day was successfully created."
      redirect_to days_path
    else
      render :new, status: :unprocessable_entity
    end
  end

private

  def day_params
    params.require(:day).permit(:day, :active_flag)
  end

end