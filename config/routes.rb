Rails.application.routes.draw do
  resources :comments
  resources :todos
  resources :tasks
  resources :categories
  resources :users
  get '/profile', to: 'users#me'
  post '/sessions', to: 'authentication#login'
  post '/todos/:id/members', to: 'todos#add_member'
  delete '/todos/:id/members/:member_id', to: 'todos#destroy_member'
  post '/todos/:id/tasks', to: 'tasks#create'
  put '/todos/:id/tasks/:task_id', to: 'tasks#update'
  delete '/todos/:id/tasks/:task_id', to: 'tasks#destroy'
  post '/todos/:id/comments', to: 'comments#create'
  delete '/todos/:id/comments/:comment_id', to: 'comments#destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
