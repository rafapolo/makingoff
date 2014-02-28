require 'sidekiq/web'

Makingoff::Application.routes.draw do

  mount Sidekiq::Web, at: "/sidekiq"

  resources :countries
  resources :genres
  resources :directors
  resources :movies

  get '/autocomplete.json', to: "movies#autocomplete"
  get '/:urlized', to: "movies#show"
  get '/list/:tipo/:id', to: "movies#list"
  get '/list/cor/:cor', to: "movies#cor"
  root 'movies#info'

end
