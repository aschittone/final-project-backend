class Api::V1::AuthController < ApplicationController

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      payload = { user_id: user.id}
      token = issue_token(payload)
      render json: {msg: "Success", user: user, jwt: token}
		else
			render json: {msg: 'Username or Password in correct'}
    end
  end
end
