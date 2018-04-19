require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class DolarController < ApplicationController

  def index
  end


  def get_dolar_values
    @titulo="Dolar"
  end

  def show_dolar_values
    @titulo="Dolar"
    fecha_inicio_format= params[:fecha_inicio]
    fecha_final_format= params[:fecha_final]
    @result = Dolar.get_api_value(fecha_inicio_format, fecha_final_format)
    @data_table_max_min_dolar_value=Dolar.generate_dashboard_value(@result,fecha_inicio_format, fecha_final_format)
    @tweets_count=Dolar.data_table(@result,fecha_inicio_format, fecha_final_format)
    @data_bock=Dolar.data_bock(@result,fecha_inicio_format, fecha_final_format)
    @fecha_inicio=fecha_inicio_format
    @fecha_final=fecha_final_format
  end

end
