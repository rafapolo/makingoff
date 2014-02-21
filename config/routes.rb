Makingoff::Application.routes.draw do
  resources :countries
  resources :genres
  resources :directors
  resources :movies

  get '/autocomplete.json', to: "movies#autocomplete"

  root 'movies#index'
end
