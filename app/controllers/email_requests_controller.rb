class EmailRequestsController < ApplicationController

def index
end

def show
  @email_request = EmailRequest.find(params[:id])
end

def new
  @email_request = EmailRequest.new
end

def create
  @email_request = EmailRequest.new(email_request_params)
  @recaptcha_succeeded = verify_recaptcha(model: @email_request)
  

  respond_to do |format|
    if @recaptcha_succeeded && @email_request.save && !@email_request.email.match(/(.ru)/) && !email_request.body.match(/[\u0401\u0451\u0410-\u044f]/)

      flash[:success] = "Thank you for your note. We will respond as soon as possible."
      format.html { redirect_to params[:previous_request] }
      format.json { render :show, status: :created, location: @email_request }
    else
      flash.now[:warning] = "no email sent"
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @email_request.errors, status: :unprocessable_entity }
    end
  end
end

def update

  @email_request = EmailRequest.find(params[:id])
    

    if @email_request.update(archive: params[:archive])

      flash[:success] = "Email was successfully archived"
      redirect_to admin_emails_path
    else
      render :new, status: :unprocessable_entity
    end
end

def destroy

  @email_request = EmailRequest.find(params[:id])
  @email_request.destroy

  respond_to do |format|
    flash[:success] = "email was was successfully deleted."

    format.html { redirect_to admin_emails_path }
    format.json { head :no_content }
  end

end

def forward_email
  @email_request = EmailRequest.find(params[:id])
  @send_to_email = current_user.email

  EmailRequestMailer.forward(@send_to_email, @email_request.id).deliver_now
  flash[:success] = "Item has been forwarded to your email"
  redirect_to admin_emails_path 


end

def trello_ride_request
  @email_request = EmailRequest.find(params[:id])

  EmailRequestMailer.trello_ride(@email_request.id).deliver_now
  flash[:success] = "Item has been sent to Trello Board for Ride Requests"
  redirect_to admin_emails_path 

end

def trello_membership_request
  @email_request = EmailRequest.find(params[:id])

  EmailRequestMailer.trello_member(@email_request.id).deliver_now
  flash[:success] = "Item has been sent to Trello Board for Membership Requests"
  redirect_to admin_emails_path 

end

private

    # Only allow a list of trusted parameters through.
    def email_request_params
      params.require(:email_request).permit(:date, :email, :subject, :body, :ride, :membership, :general, :instruction, :previous_request, :query)
    end

  

end