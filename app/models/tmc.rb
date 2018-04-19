require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class Tmc < ApplicationRecord


  def self.get_info_for_table(fecha_inicio_format, fecha_final_format)
      @result=[]

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

  def self.get_db_value(fecha_inicio, fecha_final)
    @resultDB=Tmc.where("fecha <= ? AND fecha > ?", fecha_final, fecha_inicio)

  end

  def self.get_api_value(fecha_inicio, fecha_final)
    if(!fecha_inicio.empty? && !fecha_final.empty?)


      fecha_inicio=fecha_inicio.split("-")[0]+"/"+ fecha_inicio.split("-")[1]
      fecha_final=fecha_final.split("-")[0]+"/"+ fecha_final.split("-")[1]
     request_uri="https://api.sbif.cl/api-sbifv3/recursos_api/tmc/periodo/"+fecha_inicio+"/"+fecha_final+"?apikey=b8124793da9ca97350a3be40583dd49e1c07e51c&formato=json"
      buffer = open(request_uri).read
      #@result = JSON.parse("{}")
      @result = JSON.parse(buffer)
    else
      @result = JSON.parse("{}")
    end
  end

  def self.fake(listaJsonTmc)
    count=0
    listaTmc=[]
    if( listaJsonTmc.size>=1)
      listaJsonTmc['TMCs'].each do |tmcJson|
        tmc = Tmc.new
        tmc.fecha = tmcJson['Fecha']
        tmc.titulo = tmcJson['Titulo']
        tmc.subtitulo = tmcJson['SubTitulo']
        tmc.valor = tmcJson['Valor']
        tmc.tipo = tmcJson['Tipo']
        listaTmc << [tmcJson['Fecha'], tmcJson['Valor'], tmcJson['Titulo'], tmcJson['SubTitulo'], tmcJson['Tipo']]
        tmc.save
        #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
        #count=count+1
        #dolar.save
      end
    end
    @result=listaTmc

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

  def self.converter_data(listaDolarValor)
    count=0
    listaDolar=[]
    if( listaDolarValor.size>=1)
      listaDolarValor['TMCs'].each do |dolar_response|
        tmc = Tmc.new
        tmc.titulo=dolar_response['Titulo']
        tmc.valor=dolar_response['Valor']
        tmc.subtitulo=dolar_response['SubTitulo']
        tmc.tipo=dolar_response['Tipo']
        tmc.fecha=dolar_response['Fecha']
        #dolar.fecha_consulta = dolar_response['Fecha']
        #dolar.valor_en_peso = dolar_response['Valor']
        listaDolar << tmc
        #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
        #count=count+1
        #dolar.save
      end
    end

    tipoTmcFlag=nil
    listaAgrupadaPorTipo=[]
    tmc_convertido={}
    listaTmc_convertido=[]
    tmc_desc=[]
    tmcMaximo=0
    flag_init=1




    listaAgrupadaPorTipo=listaDolar.sort_by{|obj| obj[:tipo] }

    listTmcMaximo=[]
    listaAgrupadaPorTipo.each do |tmc_desc|

      if(tmc_desc.tipo != tipoTmcFlag )

        tmc_convertido[:titulo]=tmc_desc.titulo
        tmc_convertido[:subtitulo]=tmc_desc.subtitulo
        tmc_convertido[:tipo]=tmc_desc.tipo
        tmc_convertido[:valorMax]=0

        tipoTmcFlag=tmc_desc.tipo

      else





      end




      listaTmc_convertido << tmc_convertido
      tmc_convertido={}
    end

    @result=listaTmc_convertido
  end

end
