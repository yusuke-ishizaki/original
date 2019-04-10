Rails.application.routes.draw do
  #ポート番号３３３３
  devise_for :users
  root 'posts#index'
  resources :posts
  get   'users/:id'   =>  'users#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
