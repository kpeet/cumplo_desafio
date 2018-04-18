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





  end

  def get tmc_values

  end

  def accion_a_realizar

    fecha_inicio_format= params[:fecha_inicio]
    fecha_final_format= params[:fecha_final]

    @result = Dolar.get_api_value(fecha_inicio_format, fecha_final_format)
    #@indice= params[:indice]
    puts "Fecha de inicio"
    puts @fecha_inicio
    @papita=Dolar.generate_dashboard_value(@result)
    @tweets_count=Dolar.data_table(@result)
    @fecha_inicio=fecha_inicio_format
    @fecha_final=fecha_final_format
  end

end
