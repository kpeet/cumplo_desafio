Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #

  get 'application/index'

  get 'dolar/index'
  get 'dolar/get_dolar_values'
  post 'dolar/accion_a_realizar'

  get "dolar/:accion_a_realizar" => "dolar#get_dolar_values", :as => :postdolar
  get "uf/:accion_a_realizar" => "uf#get_uf_values", :as => :postuf
  get "tmc/:show_result" => "tmc#get_tmc_values", :as => :posttmc

  get 'uf/index'
  get 'uf/get_uf_values'
  post 'uf/accion_a_realizar'

  post 'tmc/show_result'
  get 'tmc/get_tmc_values'


  root 'dolar#get_dolar_values'

end
