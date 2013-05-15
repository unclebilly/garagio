require 'rubygems'
require 'sinatra/base'
require File.expand_path("../../init", __FILE__)

class Garagio < Sinatra::Base
  set :haml, :format => :html5 # default Haml format is :xhtml

  class << self
    def wifly
      @wifly ||= Wifly::Control.new(CONFIG[:address], CONFIG[:port], CONFIG[:firmware_version])
    end
  end

  get '/' do
    @door_state = door_state
    haml :index
  end

  get '/door_state' do
    content_type 'text/plain'
    door_state
  end

  get '/toggle' do
    toggle_door
    redirect "/"
  end

  ##
  # Note to self: when you put the neodynium magnet near the relay, it tends to not 
  # work!
  #
  def toggle_door
    self.class.wifly.set_high(CONFIG[:relay_pin])
    sleep 1
    self.class.wifly.set_low(CONFIG[:relay_pin])
  end

  def door_state
    self.class.wifly.read_pin(CONFIG[:door_state_pin]) == 1 ? "closed" : "open"
  end

  run! if app_file == $0
end