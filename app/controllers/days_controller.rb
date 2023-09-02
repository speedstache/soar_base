class DaysController < ApplicationController
  helper_method :current_user, :logged_in?

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
      if @day.update(day)
        flash[:notice] = "Day was updated successfully"
          redirect_to days_path
      else
        render 'edit', status: :unprocessable_entity
      end
  end

  def create
    @day = Day.new
    if @day.save
      flash[:notice] = "day was successfully created."
      redirect_to days_path
    else
      render :new, status: :unprocessable_entity
    end
  end

private

  def day
    params.require(:day).permit(:day, :active_flag)
  end

end