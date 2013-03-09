RACK_ENV  = ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
RACK_ROOT = File.expand_path(File.dirname(__FILE__) + '/..')

unless $LOAD_PATH.include? "."
  $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
end

require 'bundler/setup'
require 'app'

run P2met::App.new
