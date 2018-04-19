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
    if(fecha_final_format=='' || fecha_inicio_format=='')

      @tweets_count=[]
    else



    #@resultDB=Tmc.get_db_value(fecha_inicio_format, fecha_final_format)
    #@rango_fechas_faltantes=Tmc.fechas_faltantes(@resultDB)

   # @result = Tmc.get_api_value(fecha_inicio_format, fecha_final_format)
    #@resultDB =Tmc.save_json_tmc(@result)
    #@tweets_count=Tmc.data_table(@result)
   #@result=Tmc.converter_data(@result)
        @result=[]
         #@tweets_count=TipoTmc.where(id_tipo: "22").joins("INNER JOIN tmcs ON tipo_tmcs.id_tipo = tmcs.tipo ")
         #@tweets_count=Tmc.where("fecha >= :start_date AND fecha <= :end_date AND tipo= 22",
                             #    {start_date: fecha_inicio_format, end_date: fecha_final_format}).joins("LEFT JOIN tipo_tmcs ON tipo_tmcs.id_tipo = tmcs.tipo ")

        tiposTMC=TipoTmc.select("id_tipo, titulo, subtitulo")

        lista_datos_tipo=[]
        lista_id_tipos=[]
        valores=[]
        tiposTMC.each do |tipos|
          if(!lista_id_tipos.include? tipos.id_tipo)
            lista_id_tipos << tipos.id_tipo
            listaValoresTmc=[]
            listaValoresFechaTmc=[]

            valores = Tmc.select("valor, fecha").where("fecha >= :start_date AND fecha <= :end_date AND tipo= :id_tipo",
                                                     {start_date: fecha_inicio_format, end_date: fecha_final_format, id_tipo: tipos.id_tipo})

            if(!valores.empty?)
              valores.each do |val|
                if(val.valor.nil?)
                  val.valor=0
                end
                listaValoresTmc << val.valor
                listaValoresFechaTmc << [val.valor, val.fecha]

              end

            end

            lista_datos_tipo << [tipos.id_tipo,listaValoresFechaTmc,listaValoresTmc.max, tipos.subtitulo, tipos.titulo]
          end
        end

        @tweets_count=lista_datos_tipo

    end




    @fecha_inicio=fecha_inicio_format
    @fecha_final=fecha_final_format
  end
end
