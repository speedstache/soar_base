class HoursController < ApplicationController
  helper_method :current_user, :logged_in?

  def index
    @hours = Hour.all
  end

  def show
    @hour = Hour.find(params[:id])
  end

  def edit
    @hour = Hour.find(params[:id])
  end

  def update
    @hour = Hour.find(params[:id])
      if @hour.update(hour_params)
        flash[:notice] = "Hour was updated successfully"
          redirect_to hours_path
      else
        render 'edit', status: :unprocessable_entity
      end
  end

private

  def hour_params
    params.require(:hour).permit(:hour, :active_flag)
  end

end