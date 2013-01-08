require 'rubygems'
require 'sinatra/base'
require File.expand_path("../init", __FILE__)

class GaragioServer < Sinatra::Base
  set :haml, :format => :html5 # default Haml format is :xhtml

  def wifly
    $wifly ||= WiFly.new(CONFIG[:address], CONFIG[:port])
  end

  get '/' do
    haml :index
  end

  get '/toggle' do
    wifly.toggle
    redirect "/"
  end

  run! if app_file == $0
end