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
  post "/listings", to: "listings#create"
  get '/listings/new', to: "listings#new", as: "new_listing"
  get '/listings/:id', to: "listings#show", as: "listing"
  put "/listings/:id", to: "listings#update"
  patch "/listings/:id", to: "listings#update"
  delete "/listings/:id", to: "listings#destroy", as: "delete_listing"
  get '/listings/:id/edit', to: "listings#edit", as: "edit_listing"

end
