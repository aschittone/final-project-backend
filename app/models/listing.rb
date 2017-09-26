class Listing < ApplicationRecord
	has_many :UserListings
	has_many :users, through: :UserListings
end
