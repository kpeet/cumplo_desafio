require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class Dolar < ApplicationRecord
  def self.get_api_value(fecha_inicio, fecha_final)
    if(!fecha_inicio.empty? && !fecha_final.empty?)


      fecha_inicio=fecha_inicio.split("-")[0]+"/"+ fecha_inicio.split("-")[1]
      fecha_final=fecha_final.split("-")[0]+"/"+ fecha_final.split("-")[1]
      indicador="dolar"
      #indicador="uf"
      request_uri = "https://api.sbif.cl/api-sbifv3/recursos_api/"+indicador+"/periodo/"+fecha_inicio+"/"+fecha_final+"?apikey=b8124793da9ca97350a3be40583dd49e1c07e51c&formato=json"
      buffer = open(request_uri).read
      #@result = JSON.parse("{}")
      @result = JSON.parse(buffer)
    else
      @result = JSON.parse("{}")
    end
  end

  def self.data_table(listaDolarValor)
    count=0
    listaDolar=[]
    if( listaDolarValor.size>=1)
      listaDolarValor['Dolares'].each do |dolar_response|
        dolar = Dolar.new
        #dolar.fecha_consulta = dolar_response['Fecha']
        #dolar.valor_en_peso = dolar_response['Valor']
        listaDolar << [dolar_response['Fecha'], dolar_response['Valor']]
        #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
        #count=count+1
        #dolar.save
      end
    end
    @result =listaDolar


  end
  def self.generate_dashboard_value(json_list_value)
    count=0
    listaDolar=[]
    listaIndices=[]
    if(json_list_value.empty? && json_list_value.size>=1)
      json_list_value['Dolares'].each do |dolar_response|
        dolar = Dolar.new
        #dolar.fecha_consulta = dolar_response['Fecha']
        #dolar.valor_en_peso = dolar_response['Valor']
        listaDolar << [dolar_response['Fecha'], dolar_response['Valor']]
        #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
        #count=count+1
        #dolar.save
        papita=listaDolar.map{|e| e[1]}


        promedioValores=promedio(papita)
        listaIndices=[["Mínimo", papita.min],["Máximo",papita.max],["Promedio",promedio(papita)] ]
      end
    end
    @result=listaIndices
  end

  def self.promedio(listValores)

    sumaDeValores=0
    count=0
    listValores.each do |valor|
      sumaDeValores=sumaDeValores+valor.to_i
      count=count+1
    end
    if(count <= 0)
      @promedio=0
    else
      @promedio=sumaDeValores/count
    end
  end
end
