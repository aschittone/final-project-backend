class Api::V1::UsersController < ApplicationController
	# before_action :authorized, only: [:me]
	
  # Takes in the sign up request, and checks to see if user's email is unique
  # Once successfully signed in, JWT token is issued
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
	
  # Gets user current listings and info
  def me
		user_listings = current_user.listings
    render json: [current_user, user_listings]
  end

  # Gets user financial info to display in front end
  def get_financials
    render json: [current_user]
  end

  # Saves a users financial profile
  def save_financials
    current_user.update(assets: params[:assets], average_annual_income: params[:average_annual_income], credit_score: params[:credit_score], total_debt: params[:total_debt])
    user_listings = current_user.listings
    render json: [current_user, user_listings]
  end

  


end