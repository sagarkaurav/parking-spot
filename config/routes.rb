Rails.application.routes.draw do
  root 'cities#index'
  get 'cities/index'
  post 'cities/find'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
