require 'logger'
require 'bundler'

Bundler.require

require File.expand_path("../config/config", __FILE__)
$: << File.expand_path("../lib", __FILE__)
require 'garagio'

RubySpark.configuration do |config|
  config.access_token = CONFIG[:access_token]
end