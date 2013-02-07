require 'logger'
require 'rubygems'
require 'bundler'

Bundler.require

require File.expand_path("../config/config", __FILE__)
$: << File.expand_path("../lib", __FILE__)
require 'wifly'
