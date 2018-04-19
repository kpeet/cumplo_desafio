class Uf < ApplicationRecord
  def self.get_api_value(fecha_inicio, fecha_final)
    if(!fecha_inicio.empty? && !fecha_final.empty?)


      fecha_inicio=fecha_inicio.split("-")[0]+"/"+ fecha_inicio.split("-")[1]
      fecha_final=fecha_final.split("-")[0]+"/"+ fecha_final.split("-")[1]
      indicador="uf"
      request_uri = "https://api.sbif.cl/api-sbifv3/recursos_api/"+indicador+"/periodo/"+fecha_inicio+"/"+fecha_final+"?apikey=b8124793da9ca97350a3be40583dd49e1c07e51c&formato=json"
      buffer = open(request_uri).read
      #@result = JSON.parse("{}")
      @result = JSON.parse(buffer)
    else
      @result = JSON.parse("{}")
    end
  end

  def self.data_table(listaUFValor,fecha_inicio_format, fecha_final_format)
    count=0
    listaUF=[]
    if( listaUFValor.size>=1)
      listaUFValor['UFs'].each do |uf_response|
        if(uf_response['Fecha'] >= fecha_inicio_format && uf_response['Fecha'] <= fecha_final_format  )

          listaUF << [uf_response['Fecha'], uf_response['Valor']]

        end
      end
    end
    @result =listaUF


  end
  def self.generate_dashboard_value(json_list_value,fecha_inicio_format, fecha_final_format)

    count=0
    listaUF=[]
    listaUF1=[]
    listaIndices=[]
    if(!json_list_value.empty? && !json_list_value['UFs'].empty?)
      json_list_value['UFs'].each do |uf_response|

        if(uf_response['Fecha'] >= fecha_inicio_format && uf_response['Fecha'] <= fecha_final_format  )

          listaUF << [uf_response['Fecha'], uf_response['Valor']]
          listaUF1 << uf_response['Valor']
        end

      end

      listaIndices=[["Mínimo", listaUF1.min],["Máximo",listaUF1.max],["Promedio",promedio(listaUF1)] ]

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
      @promedio=(sumaDeValores/count).to_f
    end
  end

  def self.data_bock(listaUfValor,fecha_inicio_format, fecha_final_format)
    count=0
    listaDolar=[]
    if( listaUfValor.size>=1)
      listaUfValor['UFs'].each do |uf_response|
        #dolar.fecha_consulta = dolar_response['Fecha']
        #dolar.valor_en_peso = dolar_response['Valor']
        #
        if(uf_response['Fecha'] >= fecha_inicio_format && uf_response['Fecha'] <= fecha_final_format  )
          listaDolar << [uf_response['Fecha'], uf_response['Valor']]
        end
        #count=count+1
        #dolar.save
      end
    end
    @result =listaDolar


  end

end
