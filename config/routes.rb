Rails.application.routes.draw do

  devise_scope :user do
    # Redirests signing out users back to sign-in
    get "users", to: "devise/sessions#new"
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"
  get "/restricted", to: "pages#restricted"
  # get 'listings/index', as: "listings"
  #   #=> same as get "/listings", to "listings#index", however must have the index parameter to work
  get '/listings', to: "listings#index", as: "listings"
  get '/listings/:id', to: "listings#show", as: "listing"
end
