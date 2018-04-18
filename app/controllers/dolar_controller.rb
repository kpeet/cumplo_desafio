require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class DolarController < ApplicationController
  include CumploHelper

  def index
  end

  def get_uf_values
    @uf=Uf.get_api_value
  end

  def get_dolar_values
    @titulo="Dolar"
  end

  def get tmc_values

  end

  def accion_a_realizar
    @titulo="Dolar"
    fecha_inicio_format= params[:fecha_inicio]
    fecha_final_format= params[:fecha_final]
    @result = Dolar.get_api_value(fecha_inicio_format, fecha_final_format)
    @data_table_max_min_dolar_value=Dolar.generate_dashboard_value(@result)
    @tweets_count=Dolar.data_table(@result)
    @fecha_inicio=fecha_inicio_format
    @fecha_final=fecha_final_format
  end

end
