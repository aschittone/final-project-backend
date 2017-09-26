class User < ApplicationRecord
	has_secure_password
	has_many :UserListings
	has_many :listings, through: :UserListings

	
end
