class PagesController < ApplicationController

  def index
    
  end


  def flights

  end

  def instruction
  
  end

  def membership
  
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field_status_update
      @field_status_update = FieldStatusUpdate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def email_request_params
      params.require(:email_request).permit(:date, :email, :subject, :body, :ride, :membership, :general, :instruction)
    end


end