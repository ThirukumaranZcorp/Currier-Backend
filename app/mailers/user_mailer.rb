class UserMailer < ApplicationMailer

  default from: 'zcorp186@gmail.com'

  def reset_password_otp(user)
    @user = user
    @otp  = user.reset_password_otp
    mail(to: @user.email, subject: "Your Password Reset OTP")
  end

end
