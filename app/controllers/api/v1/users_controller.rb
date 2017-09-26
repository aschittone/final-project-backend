class Api::V1::UsersController < ApplicationController
	# before_action :authorized, only: [:me]
	
  def create
		@user = User.new(name: params[:name], username: params[:username], password: params[:password])
		usernames = User.all.select { |user| user.username == @user.username}
		if usernames.length < 1 && @user.save
      payload = { user_id: @user.id}
      render json: {user: @user, jwt: issue_token(payload)}
    else
      render json: {msg: "Username already taken"}
    end
	end
	
  def me
		user_listings = current_user.listings
    render json: [current_user, user_listings]
  end

  


end