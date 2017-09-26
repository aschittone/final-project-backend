class Api::V1::UserListingsController < ApplicationController
	
	def create
		address = params["0"]["address"]["street"] + ", " + params["0"]["address"]["city"] + ", " + params["0"]["address"]["state"]
		lng = params["0"]["address"]["longitude"]
		lat = params["0"]["address"]["latitude"]
		rent = params["2"]
		taxes = JSON.parse(params["3"]["data"]["body"])["property"][0]["assessment"]["tax"]["taxamt"]
		@listing = Listing.new(rent: rent, address: address, taxes: taxes, latitude: lat, longitude: lng)
		listings = Listing.all.select { |listing| listing.address == @listing.address}
		if listings.length < 1 && @listing.save
			UserListing.create(user_id: current_user.id, listing_id: @listing.id)
			render json: {msg: 'Listing Saved'}
		else 
			render json: {msg: 'Listing Already Saved'}
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