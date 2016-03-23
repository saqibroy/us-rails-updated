Rails.application.routes.draw do
  get "/admin" => "admin#index", :as => 'admin'
  get 'admin/user_data'
  get 'admin/user_new'
  post 'admin/user_create'
  get 'admin/user_edit'
  put 'admin/user_update'
  delete 'admin/user_destroy'
  get 'admin/posts'
  get 'admin/post_new'
  post 'admin/post_create'
  get 'admin/post_edit'
  put 'admin/post_update'

  resources :pages
  devise_for :users, path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'secret',
      confirmation: 'verification',
      unlock: 'unblock',
      sign_up: 'register'
  }

  resources :links
  resources :comments
  resources :categories
  resources :posts
  resources :images
  get 'welcomes/home'
  get 'welcomes/contact'
  root 'welcomes#home'
  get '/change_locale/:locale', to: 'settings#change_locale', as: :change_locale

end
