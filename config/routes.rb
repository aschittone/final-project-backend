Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/listings/:address', to: 'listings#get_listing' #get initial listing info
      post '/users', to: 'users#create' #sign up a user
      post '/login', to: 'auth#create' #create session
      get '/me', to: 'users#me' #get user profile info
      post '/user/listings', to: 'user_listings#create' #user can save a listing
      delete '/user/listings/:address', to: 'user_listings#destroy' #user can delete a saved listing
      get '/user/financials', to: 'users#get_financials' #get financial data
      post '/user/financials', to: 'users#save_financials' #save financial data
      get '/listings/:address', to: 'listings#get_info'
    end
  end
end
