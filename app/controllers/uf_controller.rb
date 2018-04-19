class UfController < ApplicationController
  def index
  end


  def get_uf_values
    @titulo="UF"
  end


  def accion_a_realizar
    @titulo="UF"
    fecha_inicio_format= params[:fecha_inicio]
    fecha_final_format= params[:fecha_final]
    @result = Uf.get_api_value(fecha_inicio_format, fecha_final_format)
    if(@result.empty?)
      @tweets_count=[]
    else
      @data_table_max_min_dolar_value=Uf.generate_dashboard_value(@result,fecha_inicio_format, fecha_final_format)
      @tweets_count=Uf.data_table(@result,fecha_inicio_format, fecha_final_format)
      @data_bock=Uf.data_bock(@result,fecha_inicio_format, fecha_final_format)
    end

    @fecha_inicio=fecha_inicio_format
    @fecha_final=fecha_final_format
  end
end
