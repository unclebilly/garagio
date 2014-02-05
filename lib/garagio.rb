require 'rubygems'
require 'sinatra/base'
require 'sinatra/flash'
require File.expand_path("../../init", __FILE__)

class Garagio < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  set :haml, :format => :html5 # default Haml format is :xhtml

  before do
    error 401 unless authentic?
  end

  after do
    wifly.close
  end

  def wifly
    @wifly ||= Wifly::Control.new(CONFIG[:address], CONFIG[:port])
  end

  get '/' do
    @door_state = door_state
    haml :index
  end

  get '/door_state' do
    content_type 'text/plain'
    door_state
  end

  post '/toggle' do
    if(validate_passcode)
      toggle_door
    end
    redirect "/?auth_token=#{@params[:auth_token]}"
  end

  ##
  # Note to self: when you put the neodymium magnet near the relay, it tends to not 
  # work!
  #
  def toggle_door
    self.wifly.set_high(CONFIG[:relay_pin])
    sleep 1
    self.wifly.set_low(CONFIG[:relay_pin])
  end

  def door_state
    self.wifly.read_pin(CONFIG[:door_state_pin]) == 0 ? "closed" : "open"
  end

  def authentic?
    params[:auth_token] == CONFIG[:auth_token]
  end

  def validate_passcode
    unless params[:passcode].to_s.strip == CONFIG[:passcode].to_s
      flash[:fatal] = "Invalid passcode"
      false
    else
      true
    end
  end
end