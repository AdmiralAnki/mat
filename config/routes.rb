Rails.application.routes.draw do
  
  resources :tests
  get 'users/new'
  post 'users/show'
  get 'users/login_auth'
  get 'users/login'
  get 'users/welcome_page' => '/'
  get 'users/logout'
  get 'users/admin'
  get 'users/admin_auth'
  get 'users/admin_logout'
  get 'users/user_page'
  get 'users/search'
  get 'users/search_profile'
  post 'users/express'
  get 'users/view_messages'
  get 'admin_logout' => 'users#admin_logout'

  get 'users/approve'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#welcome_page'
  resources :users
end
