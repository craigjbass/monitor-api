require 'sinatra'

module DeliveryMechanism
  class WebRoutes < Sinatra::Base
    get '/' do
      'hello world'
    end
  end
end
