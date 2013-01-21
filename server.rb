require 'rubygems'
require 'sinatra/base'
require File.expand_path("../init", __FILE__)

class GaragioServer < Sinatra::Base
  set :haml, :format => :html5 # default Haml format is :xhtml

  class << self
    def wifly
      @wifly ||= WiFly.new(CONFIG[:address], CONFIG[:port])
    end
  end

  get '/' do
    @door_state = self.class.wifly.door_state
    haml :index
  end

  get '/door_state' do
    self.class.wifly.door_state
  end

  get '/lites' do
    self.class.wifly.lites
    redirect "/"
  end

  run! if app_file == $0
end