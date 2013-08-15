Regidoc::Application.routes.draw do
  get "stories/index"
  get "stories/new"
  resources :stories
  root :to => 'visitors#new'
end
