# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  enum role: %i[user admin]
  after_initialize :set_default_role, if: :new_record?
  has_many :transactions, foreign_key: :user_id, dependent: :delete_all
  after_create :set_verification_code, :send_welcome_email

  private

  def set_verification_code
    self.verification_code = SecureRandom.hex(4)
  end

  def set_default_role
    self.role ||= :user
  end

  def send_welcome_email
    mail = UserMailer.welcome_email(self, verification_code)
    mail.deliver_now!
  end
end
