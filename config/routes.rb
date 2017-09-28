Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/listings/:address', to: 'listings#get_listing'
      post '/users', to: 'users#create'
      post '/login', to: 'auth#create'
      get '/me', to: 'users#me'
      post '/user/listings', to: 'user_listings#create'
      delete '/user/listings/:address', to: 'user_listings#destroy'
      get '/user/financials', to: 'users#get_financials'
      post '/user/financials', to: 'users#save_financials'
      
      
      
    end
  end
end
