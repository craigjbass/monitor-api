require 'sinatra'

module DeliveryMechanism
  class WebRoutes < Sinatra::Base
    before do
      @use_case_factory = Dependencies.use_case_factory
    end

    get '/project/find' do
      return 404 if request.env['rack.request.query_hash']['id'].nil?

      return_project = @use_case_factory.get_use_case(:find_project).execute(id: params['id'].to_i)

      content_type 'application/json'
      response.body = {
        type: return_project.type,
        data: return_project.data
      }.to_json
      response.status = 200
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

    post '/project/update' do
      request_body = JSON.parse(request.body.read)

      if valid_update_request_body(request_body)
        use_case = @use_case_factory.get_use_case(:update_project)
        success = use_case.execute(
          id: request_body['id'],
          project: {
            type: request_body['project']['type'],
            baseline: request_body['project']['baselineData']
          }
        )
        response.status = success[:success] != 'true' ? 404 : 200
      else
        response.status = 404
      end
    end

    private

    def valid_update_request_body(request_body)
      !request_body.dig('id').nil? &&
        !request_body.dig('project', 'type').nil? &&
        !request_body.dig('project', 'baselineData').nil?
    end
  end
end
