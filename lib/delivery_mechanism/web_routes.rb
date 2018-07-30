# frozen_string_literal: true

require 'sinatra'

module DeliveryMechanism
  class WebRoutes < Sinatra::Base
    before do
      @use_case_factory = Dependencies.use_case_factory
      response.headers['Access-Control-Allow-Origin'] = '*'
    end

    after do
      @use_case_factory.database.disconnect
    end

    options '*' do
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Accept'
      200
    end

    post '/return/create' do
      body = request.body.read
      if body.to_s.empty?
        response.status = 400

      else
        request_body = JSON.parse(body)
        return_id = @use_case_factory.get_use_case(:create_return).execute(
          project_id: request_body['project_id'], data:
          Common::DeepSymbolizeKeys.to_symbolized_hash(request_body['data'])
        )
        response.body = { id: return_id[:id] }.to_json
        response.status = 200
      end
      response
    end

    get '/return/get' do
      return 400 if params['id'].nil?

      return_hash = @use_case_factory.get_use_case(:get_return).execute(id: params['id'].to_i)
      if return_hash.empty?
        response.status = 404
      else
        response.body = return_hash.to_json
        response.status = 200
      end
    end

    get '/project/:id/return' do
      return 400 if params['id'].nil?

      base_return = @use_case_factory.get_use_case(:get_base_return).execute(
        project_id: params['id'].to_i
      )

      if base_return.empty?
        response.status = 404
      else
        response.status = 200
        response.body = { baseReturn: base_return[:base_return] }.to_json
      end
    end

    get '/project/find' do
      return 404 if params['id'].nil?

      return_project = @use_case_factory.get_use_case(:find_project).execute(id: params['id'].to_i)

      return 404 if return_project.nil?

      content_type 'application/json'
      response.body = {
        type: return_project.type,
        data: Common::DeepCamelizeKeys.to_camelized_hash(return_project.data)
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
        update_successful = use_case.execute(
          id: request_body['id'].to_i,
          project: {
            type: request_body['project']['type'],
            baseline: request_body['project']['baselineData']
          }
        )[:successful]
        response.status = update_successful ? 200 : 404
      else
        response.status = 400
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
