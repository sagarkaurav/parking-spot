Rails.application.routes.draw do
  root 'cities#index'

  get 'cities/index'
  post 'cities/find'

  get '/:city_name', to: 'parkings#index', as: 'parkings'
  get 'parkings/book/:parking_id', to:'parkings#book', as: 'parkings/book'
  post 'parkings/ticket'
  get 'tickets/payment'
  post 'tickets/payment_complete'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
