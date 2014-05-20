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

  def device
    @device ||= RubySpark::Tinker.new(GaragioConfig[:device_id])
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
    redirect "/?access_token=#{@params[:access_token]}"
  end

  ##
  # Note to self: when you put the neodymium magnet near the relay, it tends to not 
  # work!
  #
  def toggle_door
    self.device.digital_write(GaragioConfig[:relay_pin], 'HIGH')
    sleep 1
    self.device.digital_write(GaragioConfig[:relay_pin], 'LOW')
  end

  def door_state
    self.device.digital_read(GaragioConfig[:door_state_pin]) == 'LOW' ? "closed" : "open"
  end

  def authentic?
    true
  end

  def validate_passcode
    unless params[:passcode].to_s.strip == GaragioConfig[:passcode].to_s
      flash[:fatal] = "Invalid passcode"
      false
    else
      true
    end
  end
end