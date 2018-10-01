RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)
require './lib/loader.rb'

unless ENV['SENTRY_DSN'].nil?
  require 'raven'
  Raven.configure { |config| config.dsn = ENV['SENTRY_DSN'] }
  use Raven::Rack
end

run DeliveryMechanism::WebRoutes
