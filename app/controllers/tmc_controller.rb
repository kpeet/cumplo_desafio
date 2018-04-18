require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class TmcController < ApplicationController
  def index


  end

  def get_dolar_values





  end

  def get_tmc_values
    @titulo="TMC"
    @result=[]

  end

  def show_result
    @titulo="TMC"
    fecha_inicio_format= params[:fecha_inicio]
    fecha_final_format= params[:fecha_final]
    #@resultDB=Tmc.get_db_value(fecha_inicio_format, fecha_final_format)
    #@rango_fechas_faltantes=Tmc.fechas_faltantes(@resultDB)

    @result = Tmc.get_api_value(fecha_inicio_format, fecha_final_format)
    @resultDB =Tmc.save_json_tmc(@result)
    @tweets_count=Tmc.data_table(@result)
    @result=Tmc.converter_data(@result)

    @fecha_inicio=fecha_inicio_format
    @fecha_final=fecha_final_format
  end
end
