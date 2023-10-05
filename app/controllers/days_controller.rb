class DaysController < ApplicationController
  before_action :require_user

  def new
    @day = Day.new
  end
  
  def index
    @days = Day.order('days.day ASC').all
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
        format.html { redirect_to days_path, notice: "Day was successfully updated." }
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
      flash[:notice] = "day was successfully created."
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