class UserMailer < ApplicationMailer
  def welcome_email(user, verification_code)
    @user = user
    @verification_code = verification_code
    # mail(from: 'adebowalevictorjheart@gmail.com', to: @user.email, subject: 'You got a new order!')
    mail(
      to: @user.email,
      subject: 'You got a new order!',
      delivery_method_options: {
        api_key: '47991657611ddfca9e6c25ea83a385bc',
        secret_key: '0211f9be0a6efe9fc8bb37f37c64c9a7',
        version: 'v3.1'
      }
    )
  end
end
# 0211f9be0a6efe9fc8bb37f37c64c9a7 SECRET MAILJET 47991657611ddfca9e6c25ea83a385bc apikey