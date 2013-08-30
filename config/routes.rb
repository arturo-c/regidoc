Regidoc::Application.routes.draw do
  get "stories/index"
  get "stories/new"
  get "stories/create_pivotal_story"
  get "users/logout"
  resources :stories
  resources :users
  root :to => 'users#new'

end
