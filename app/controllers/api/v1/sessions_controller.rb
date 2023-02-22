class Api::V1::SessionsController < ApplicationController
  def verify
    email = params[:email]
    @verification_code = params[:verification_code]

    @user = User.find_by(email: email)

    if @user && @user.verification_code == @verification_code
      # Verification successful, create a session and return an access token
      # access_token = @user.create_token
      # render json: { access_token: access_token }, status: :created
      if @user.verified
        render json: { message: 'User is already verified.' }
      else
        # Verification successful, update the user's verified flag
        @user.update(verified: true)
        # Return a success message
        access_token = @user.create_token
        render json: { access_token: access_token, message: 'Verification successful.' }, status: :created
      end
    else
      # Verification failed, return an error message
      render json: { error: 'Invalid verification code' }, status: :unprocessable_entity
    end
  end
end
