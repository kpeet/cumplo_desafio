require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class Dolar < ApplicationRecord
  def self.get_api_value
    indicador="dolar"
    #indicador="uf"
    request_uri = "https://api.sbif.cl/api-sbifv3/recursos_api/"+indicador+"/periodo/2010/03/2010/05?apikey=b8124793da9ca97350a3be40583dd49e1c07e51c&formato=json"
    buffer = open(request_uri).read
    @result = JSON.parse(buffer)
  end

  def self.data_table(listaDolarValor)
    count=0
    listaDolar=[]
    listaDolarValor['Dolares'].each do |dolar_response|
      dolar = Dolar.new
      #dolar.fecha_consulta = dolar_response['Fecha']
      #dolar.valor_en_peso = dolar_response['Valor']
      listaDolar << [dolar_response['Fecha'], dolar_response['Valor']]
      #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
      #count=count+1
      #dolar.save
    end
    @result = listaDolar

  end
  def self.generate_dashboard_value(json_list_value)
    count=0
    listaDolar=[]
    json_list_value['Dolares'].each do |dolar_response|
      dolar = Dolar.new
      #dolar.fecha_consulta = dolar_response['Fecha']
      #dolar.valor_en_peso = dolar_response['Valor']
      listaDolar << [dolar_response['Fecha'], dolar_response['Valor']]
      #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
      #count=count+1
      #dolar.save
    end

    papita=listaDolar.map{|e| e[1]}


    promedioValores=promedio(papita)
    listaIndices=[["Mínimo", papita.min],["Máximo",papita.max],["Promedio",promedio(papita)] ]
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
