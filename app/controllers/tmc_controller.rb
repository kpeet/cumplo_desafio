require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class TmcController < ApplicationController
  def get_tmc_values
    @titulo="TMC"
    @result=[]

  end

  def show_result
    @titulo="TMC"
    fecha_inicio_format= params[:fecha_inicio]
    fecha_final_format= params[:fecha_final]

    @requestApi=Tmc.get_api_value(fecha_inicio_format, fecha_final_format)

    #Tmc.save_json_tmc(@requestApi)

    if( (fecha_final_format=='' || fecha_inicio_format=='') || (fecha_final_format <  fecha_inicio_format))
      @tmc_info=[]
    else
      @tmc_info = Tmc.prepare_date_for_table(@requestApi,fecha_inicio_format, fecha_final_format)
      @fecha_inicio=fecha_inicio_format
      @fecha_final=fecha_final_format
    end
  end

end
