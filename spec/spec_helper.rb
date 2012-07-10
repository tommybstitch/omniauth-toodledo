#$:.unshift File.expand_path('..', __FILE__)
#$:.unshift File.expand_path('../../lib', __FILE__)
#require 'simplecov'
require 'rspec'
require 'omniauth-toodledo'
require 'webmock/rspec'
require 'rack/test'

include Rack::Test::Methods
include WebMock::API

#WebMock.allow_net_connect!
