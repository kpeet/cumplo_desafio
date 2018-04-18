Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  get 'dolar/index'
  get 'application/index'
  get 'dolar/get_dolar_values'
  get 'dolar/get_uf_values'
  post 'dolar/accion_a_realizar'
  root 'dolar#index'

end
