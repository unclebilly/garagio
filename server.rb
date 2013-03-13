require 'rubygems'
require 'sinatra/base'
require File.expand_path("../init", __FILE__)

class GaragioServer < Sinatra::Base
  set :haml, :format => :html5 # default Haml format is :xhtml

  class << self
    def wifly
      @wifly ||= WiFly.new
    end
  end

  get '/' do
    @door_state = self.class.wifly.door_state
    haml :index
  end

  get '/door_state' do
    content_type 'text/plain'
    self.class.wifly.door_state.to_s
  end

  get '/toggle' do
    self.class.wifly.toggle_door
    redirect "/"
  end

  run! if app_file == $0
end