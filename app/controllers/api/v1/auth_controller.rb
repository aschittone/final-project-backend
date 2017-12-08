class Api::V1::AuthController < ApplicationController

  # This is contoller that takes in the log in request
  # JWT token is issued upon successful log in
  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id}
      token = issue_token(payload)
      render json: {msg: "Success", user: user, jwt: token}
		else
			render json: {msg: 'Username or Password incorrect'}
    end
  end
end
