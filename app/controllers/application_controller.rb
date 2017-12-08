class ApplicationController < ActionController::API
  # All other controllers inherit from this controller, so these functions are used throughout other controllers


	# this will take a hash and return a jwt token
  def issue_token(payload)
    JWT.encode(payload, "secret")
  end

  # Decodes the JWT token 
  def decoded_token(token)
		begin
      JWT.decode(token, "secret", false) # Returns [{}, {}, {}]
    rescue JWT::DecodeError
      []
    end
	end
  
  # Gets JWT token if there is one
  def token
    if bearer_token = request.headers["Authorization"]
      jwt_token = bearer_token.split(" ")[1]
    end
  end

  # Finds current user, if no current user, returns "hello from current User"
	def current_user
    decoded_hash = decoded_token(token)
    if !decoded_hash.empty?
      user_id = decoded_hash[0]["user_id"]
			user = User.find(user_id)
		else
			return "hello from current User"
    end
  end

  # Checks if user is logged in or not
  def logged_in?
    !!current_user
  end

  # This function can be used to check if authorized for specific actions
  def authorized
    redirect_to '/api/v1/login' unless logged_in?
  end

end
