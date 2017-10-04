class Api::V1::UserListingsController < ApplicationController
	
	def create
		if current_user == "hello from current User"
			render json: {msg: 'You must be logged in to save'}
		else
			address = params["0"]["address"]["street"] + ", " + params["0"]["address"]["city"] + ", " + params["0"]["address"]["state"]
			lng = params["0"]["address"]["longitude"]
			lat = params["0"]["address"]["latitude"]
			rent = params["2"]
			if params["3"] == "tax data not available"
				taxes = 0
			else 
				taxes = JSON.parse(params["3"]["data"]["body"])["property"][0]["assessment"]["tax"]["taxamt"]	
			end
			@listing = Listing.find_or_create_by(rent: rent, address: address, taxes: taxes, latitude: lat, longitude: lng)
			user_listings = UserListing.all.select { |user_listing| user_listing.listing_id == @listing.id && user_listing.user_id == current_user.id}
			if user_listings.length < 1 && @listing.save
				UserListing.create(user_id: current_user.id, listing_id: @listing.id)
				render json: {msg: 'Listing Saved'}
			else 
				render json: {msg: 'Listing Already Saved'}
			end
		end
	end

	def destroy 
		listing = Listing.find_by(address: params[:address])
		user_listing = UserListing.find_by(listing_id: listing.id)
		listing.destroy
		user_listing.destroy
    user_listings = current_user.listings
    render json: [current_user, user_listings]
  end

end