class Api::V1::SessionsController < ApplicationController
  # POST /api/v1/auth/sign_in
  def create
    user = User.find_for_database_authentication(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      sign_in(user, store: false) # ✅ prevents session storage
      render json: {
        user: user.as_json(only: [:id, :email, :name , :role]),
        token: request.env['warden-jwt_auth.token']
      }, status: :ok
    else
      render json: { error: "Invalid Email or Password" }, status: :unauthorized
    end
  end

  # DELETE /api/v1/auth/sign_out
  def destroy
    sign_out(current_user) # still safe, devise-jwt revokes token
    head :no_content
  end


  # Step 1: Request OTP
  def send_otp
    user = User.find_by(email: params[:email])
    if user
      otp = user.generate_reset_password_otp!
      UserMailer.reset_password_otp(user).deliver_later
      render json: { message: "OTP sent to email." }
    else
      render json: { error: "Email not found" }, status: :not_found
    end
  end

  # Step 2: Verify OTP
  def verify_otp
    user = User.find_by(email: params[:email])
    if user&.valid_reset_password_otp?(params[:otp])
      render json: { message: "OTP verified. Proceed to reset password." }
    else
      render json: { error: "Invalid or expired OTP" }, status: :unprocessable_entity
    end
  end

  # Step 3: Reset password
  def reset_password
    user = User.find_by(email: params[:email])
    if user&.valid_reset_password_otp?(params[:otp])
      if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        user.clear_reset_password_otp!
        render json: { message: "Password reset successfully" }
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid or expired OTP" }, status: :unprocessable_entity
    end
  end


  # POST /change_password
  def change_password
    user = current_user

    # Check if current password matches
    if user.valid_password?(params[:current_password])
      if params[:new_password] == params[:confirm_password]
        if user.update(password: params[:new_password], password_confirmation: params[:confirm_password])
          render json: { message: "Password updated successfully." }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: "New password and confirm password do not match." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Current password is incorrect." }, status: :unprocessable_entity
    end
  end


  
end
