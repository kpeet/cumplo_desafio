require 'open-uri'
require 'json'
require 'net/https'
require 'uri'

class DolarController < ApplicationController
  include CumploHelper

  def index

  end

  def get_uf_values
    @uf=Uf.get_api_value
  end

  def get_dolar_values
    @result = Dolar.get_api_value
    @papita=Dolar.generate_dashboard_value(@result)
    @tweets_count=Dolar.data_table(@result)

  end

  def get tmc_values

  end

end
