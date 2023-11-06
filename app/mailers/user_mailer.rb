class UserMailer < ApplicationMailer

  def account_activation(user)  
    @user = user
    mail to: user.email, subject: "Eagleville Soaring Club - Account activation"
  end

  def resend_activation(user)  
    @user = user
    mail to: user.email, subject: "Eagleville Soaring Club - Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Eagleville Soaring Club - Password reset"
  end
  
end