Rails.application.routes.draw do
  resources :todos
  resources :categories
  resources :users
  get '/profile', to: 'users#me'
  post '/sessions', to: 'authentication#login'
  post '/todos/:id/members', to: 'todos#add_member'
  delete '/todos/:id/members/:member_id', to: 'todos#destroy_member'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
