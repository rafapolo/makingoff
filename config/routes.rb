require 'sidekiq/web'

Makingoff::Application.routes.draw do

  mount Sidekiq::Web, at: "/sidekiq" if Rails.env.development?

  resources :countries
  resources :genres
  resources :directors
  resources :movies

  get '/autocomplete.json', to: "movies#autocomplete"
  get '/filme/:urlized', to: "movies#show"
  get '/list/:tipo/:id', to: "movies#list"
  get '/status/:cor', to: "movies#status"
  get '/ano/:ano', to: "movies#ano"
  get '/sitemap.xml' => "movies#sitemap"
  root 'movies#info'

end
