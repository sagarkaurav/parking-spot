Rails.application.routes.draw do
  devise_for :users
  root 'cities#index'

  get 'cities/index'
  post 'cities/find'

  get '/:city_name', to: 'parkings#index', as: 'parkings'
  get 'parkings/book/:parking_id', to:'parkings#book', as: 'parkings/book'
  post 'parkings/ticket'
  get 'tickets/payment'
  post 'tickets/payment_complete'

  get 'admin_panel/index'
  get 'admin_panel/login'
  post 'admin_panel/attempt_login'
  delete 'admin_panel/logout'
  get 'admin_panel/checkin'
  get 'admin_panel/checkout'
  post 'admin_panel/do_checkin'
  post 'admin_panel/do_checkout'
  post 'admin_panel/checkout_extra_amount'
  get 'admin_panel/ticket'
  post 'admin_panel/book_ticket'
  post 'admin_panel/complete_ticket_payment'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
