require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class Tmc < ApplicationRecord

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

  def self.save_json_tmc(listaJsonTmc)
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

  def self.data_table(listaDolarValor)

    count=0
    listaTipo=[]
    algo=[]


    listaConcosas=[{tipo: {lista_valores: [:lista_valores],valor_maximo: [:valor_maximo]} , data:  {titulo: [:titulo],subtitulo: [:subtitulo], id_tipo: [:id_tipo]}}]


    if( listaDolarValor.size >= 1)
      listaDolarValor['TMCs'].each do |dolar_response|

        tmc_tipo=TipoTmc.new
        tmc_tipo.subtitulo=dolar_response['SubTitulo']
        tmc_tipo.titulo=dolar_response['titulo']
        tmc_tipo.id_tipo=dolar_response['Tipo']
        tmc_tipo.save

        tmc_fecha=Tmc.new
        tmc_fecha.fecha=dolar_response['Fecha']
        tmc_fecha.valor=dolar_response['valor']
        tmc_fecha.tipo=dolar_response['Tipo']
        tmc_fecha.save



        #sort_by {|elem| elem[:name]}
        #
        #
        #dolar.fecha_consulta = dolar_response['Fecha']
        #dolar.valor_en_peso = dolar_response['Valor']

        #listaDolar << {:tipo => dolar_response['Tipo'] , :fecha => dolar_response['Fecha'],:valor => dolar_response['Valor']} # :valor => dolar_response['Valor'], :titulo => dolar_response['Titulo'], :subtitulo => dolar_response['SubTitulo'], }
        #listaTipo << { :tmc => {:tipo => dolar_response['Tipo'], :fecha => dolar_response['Fecha'] , :valor => dolar_response['Valor'],:titulo => dolar_response['Titulo'],:subtitulo => dolar_response['SubTitulo']} }# :valor => dolar_response['Valor'], :titulo => dolar_response['Titulo'], :subtitulo => dolar_response['SubTitulo'], }

        #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
        #count=count+1
        #dolar.save
      end

      algo=[]#TipoTmc.all#joins("INNER JOIN tmcs ON tipo_tmcs.id_tipo = tmcs.tipo ").where(id_tipo: 22)

    end
   # @result =listaTripo.sort_by{|v,t,s| v[:titulo]}
   #
   #
   #  listaAGRUPADA_porTIPO={}
   # my_hash={}
    #listaAGRUPADA_porTIPO = listaTipo.group_by{|tipo,valor,titulo,subtitulo| tipo[:Tipo]}

   #listaAGRUPADA_porTIPO.map{|k,v| {k.gsub(" 00:00:00+00","") => v}}.reduce(:merge)
   #listaAGRUPADA_porTIPO.map{|tipo,valor,titulo,subtitulo| {k.gsub(" 00:00:00+00","") => v}}.reduce(:merge)
   hsh={}
   hsh=listaTipo.group_by{|tipo, fecha, valor, titulo, subtitulo| tipo[:tipo] }.reduce(:+)
    @result=algo



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
