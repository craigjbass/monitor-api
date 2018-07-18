require_relative '../spec_helper'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app(app = nil, &blk)
    @app ||= block_given? ? app.instance_eval(&blk) : app
    @app ||= DeliveryMechanism::WebRoutes
  end
end