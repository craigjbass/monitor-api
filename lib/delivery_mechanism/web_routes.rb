require 'sinatra'

module DeliveryMechanism
  class WebRoutes < Sinatra::Base
    before do
      @use_case_factory = Dependencies.use_case_factory
    end

    get '/' do
      'hello world'
    end

    post '/project/create' do
      request_body = JSON.parse(request.body.read)

      use_case = @use_case_factory.get_use_case(:create_new_project)

      id = use_case.execute(
        type: request_body['type'],
        baseline: Common::DeepSymbolizeKeys.to_symbolized_hash(request_body['baselineData'])
      )

      content_type 'application/json'
      response.body = {
        projectId: id
      }.to_json
      response.status = 200
    end

    private
  end
end
