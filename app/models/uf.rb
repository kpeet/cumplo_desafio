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

  def self.data_table(listaUFValor)
    count=0
    listaUF=[]
    if( listaUFValor.size>=1)
      listaUFValor['UFs'].each do |uf_response|
        #uf = Uf.new
        #dolar.fecha_consulta = dolar_response['Fecha']
        #dolar.valor_en_peso = dolar_response['Valor']
        listaUF << [uf_response['Fecha'], uf_response['Valor']]
        #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
        #count=count+1
        #dolar.save
      end
    end
    @result =listaUF


  end
  def self.generate_dashboard_value(json_list_value)

    count=0
    listaUF=[]
    listaUF1=[]
    listaIndices=[]
    if(!json_list_value.empty? && !json_list_value['UFs'].empty?)
      json_list_value['UFs'].each do |uf_response|
        #uf = Uf.new
        #dolar.fecha_consulta = dolar_response['Fecha']
        #dolar.valor_en_peso = dolar_response['Valor']
        listaUF << [uf_response['Fecha'], uf_response['Valor']]
        #listaDolar[count]=[dolar_response['Fecha'], dolar_response['Valor']]
        #count=count+1
        #dolar.save
        listaUF1=listaUF.map{|e| e[1]}

        listaIndices=[["Mínimo", listaUF1.min],["Máximo",listaUF1.max],["Promedio",promedio(listaUF1)] ]

      end

    else

      listaIndices=[["Mínimo", ""],["Máximo",""],["Promedio",""] ]
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
