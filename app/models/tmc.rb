require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class Tmc < ApplicationRecord

  def self.prepare_date_for_table(listaTMCValor,fecha_inicio_format, fecha_final_format)
    if( listaTMCValor.size >= 1)
      tiposTMC=[]
      tmcList=[]
      lista_datos_tipo=[]
      lista_id_tipos=[]
      lista_id_tipos_fecha=[]
      valores=[]
      listaTMCValor['TMCs'].each do |tmc_response|


        if(!lista_id_tipos.include? [tmc_response['Tipo']])
          lista_id_tipos << [tmc_response['Tipo']]
        end
        tiposTMC << [tmc_response['SubTitulo'],tmc_response['Titulo'],tmc_response['Tipo']]
        tmcList << [tmc_response['Fecha'],tmc_response['Valor'],tmc_response['Tipo']]

      end
      tiposTMC=tiposTMC.uniq
      tiposTMC.each do |tipos|
       if(!lista_id_tipos.include? tipos[2])
          listaValoresTmc=[]
          listaValoresFechaTmc=[]

          valores=[]
          tmcList.each do |tmcs|
            if(tmcs[2]==tipos[2]  )
              valores << tmcs[1]
              listaValoresFechaTmc << [ tmcs[1], tmcs[0]]

            end
          end
              listaValoresTmc << valores

          lista_datos_tipo << [tipos[2],listaValoresFechaTmc,valores.max, tipos[0], tipos[1]]

        end

      end

    end
    @tweets_count=lista_datos_tipo
  end



  def self.get_db_value(fecha_inicio, fecha_final)
    @resultDB=Tmc.where("fecha <= ? AND fecha > ?", fecha_final, fecha_inicio)

  end

  def self.get_api_value(fecha_inicio, fecha_final)
    if(!fecha_inicio.empty? && !fecha_final.empty?)
      fecha_inicio=fecha_inicio.split("-")[0]+"/"+ fecha_inicio.split("-")[1]
      fecha_final=fecha_final.split("-")[0]+"/"+ fecha_final.split("-")[1]
     request_uri="https://api.sbif.cl/api-sbifv3/recursos_api/tmc/periodo/"+fecha_inicio+"/"+fecha_final+"?apikey=b8124793da9ca97350a3be40583dd49e1c07e51c&formato=json"
      buffer = open(request_uri).read
      @result = JSON.parse(buffer)
    else
      @result = JSON.parse("{}")
    end
  end


  def self.save_json_tmc(listaTMCValor)

    if( listaTMCValor.size >= 1)
      listaTMCValor['TMCs'].each do |tmc_response|

        tmc_tipo=TipoTmc.new
        tmc_tipo.subtitulo=tmc_response['SubTitulo']
        tmc_tipo.titulo=tmc_response['Titulo']
        tmc_tipo.id_tipo=tmc_response['Tipo']
        tmc_tipo.save

        tmc_fecha=Tmc.new
        tmc_fecha.fecha=tmc_response['Fecha']
        tmc_fecha.valor=tmc_response['valor']
        tmc_fecha.tipo=tmc_response['Tipo']
        tmc_fecha.save
      end

    end
  end


end
