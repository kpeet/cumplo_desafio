require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class Dolar < ApplicationRecord
  def self.get_api_value(fecha_inicio, fecha_final)
    if(!fecha_inicio.empty? && !fecha_final.empty?)


      fecha_inicio=fecha_inicio.split("-")[0]+"/"+fecha_inicio.split("-")[1]
      fecha_final=fecha_final.split("-")[0]+"/"+fecha_final.split("-")[1]
      indicador="dolar"
      request_uri = "https://api.sbif.cl/api-sbifv3/recursos_api/"+indicador+"/periodo/"+fecha_inicio+"/"+fecha_final+"?apikey=b8124793da9ca97350a3be40583dd49e1c07e51c&formato=json"
      buffer = open(request_uri).read
      @result =JSON.parse(buffer)
    else
      @result = JSON.parse("{}")
    end
  end

  def self.data_table(listaDolarValor,fecha_inicio_format, fecha_final_format)
    count=0
    listaDolar=[]
    if( listaDolarValor.size>=1)
      listaDolarValor['Dolares'].each do |dolar_response|

        if(dolar_response['Fecha'] >= fecha_inicio_format && dolar_response['Fecha'] <= fecha_final_format  )
          listaDolar << [dolar_response['Fecha'], dolar_response['Valor']]

        end
      end
    end
    @result =listaDolar.sort_by{ |hsh| -hsh[1]}


  end
  def self.data_bock(listaDolarValor,fecha_inicio_format, fecha_final_format)
    count=0
    listaDolar=[]
    if( listaDolarValor.size>=1)
      listaDolarValor['Dolares'].each do |dolar_response|
        if(dolar_response['Fecha'] >= fecha_inicio_format && dolar_response['Fecha'] <= fecha_final_format  )
          listaDolar << [dolar_response['Fecha'], dolar_response['Valor']]

        end
      end
    end
    @result =listaDolar


  end
  def self.generate_dashboard_value(json_list_value,fecha_inicio_format, fecha_final_format)

    count=0
    listaDolar=[]
    listaDola1r=[]
    listaIndices=[]
    if(!json_list_value.empty? && !json_list_value['Dolares'].empty?)
      json_list_value['Dolares'].each do |dolar_response|

        if(dolar_response['Fecha'] >= fecha_inicio_format && dolar_response['Fecha'] <= fecha_final_format  )

          listaDolar << [dolar_response['Fecha'], dolar_response['Valor']]
          listaDola1r << dolar_response['Valor']
        end


      end

      listaIndices=[["Mínimo", listaDola1r.min],["Máximo",listaDola1r.max],["Promedio",promedio(listaDola1r)] ]

    else

      listaIndices=[["Mínimo", ""],["Máximo",""],["Promedio",""] ]
    end
    @result=listaIndices
  end

  def self.promedio(listValores)

    sumaDeValores=0
    count=0.0
    listValores.each do |valor|
      valor_flotante=valor.to_f
      sumaDeValores=sumaDeValores+valor_flotante
      count=count+1
    end
    if(count <= 0)
      @promedio=0
    else
      @promedio=(sumaDeValores/count).to_f.round(2)
    end
  end
end
