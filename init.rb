require 'logger'
require 'bundler'

Bundler.require

$: << File.expand_path("../lib", __FILE__)
require 'garagio/garagio_config'
require 'garagio'

RubySpark.configuration do |config|
  config.access_token = GaragioConfig[:access_token]
end