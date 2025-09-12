class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self


  def generate_reset_password_otp!
    otp = rand(100000..999999).to_s
    update!(
      reset_password_otp: otp,
      reset_password_otp_sent_at: Time.current
    )
    otp
  end

  def valid_reset_password_otp?(otp)
    return false if reset_password_otp.blank?
    return false if reset_password_otp_sent_at < 10.minutes.ago
    ActiveSupport::SecurityUtils.secure_compare(reset_password_otp, otp)
  end

  def clear_reset_password_otp!
    update!(reset_password_otp: nil, reset_password_otp_sent_at: nil)
  end


end




