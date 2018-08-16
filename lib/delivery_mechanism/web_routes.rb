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

    post '/token/request' do
      request_hash = get_hash(request)
      @use_case_factory.get_use_case(:check_email).execute(email_address: request_hash[:email_address])
      @use_case_factory.get_use_case(:send_notification).execute(to: request_hash[:email_address], url: request_hash[:url])
      200
    end

    post '/return/update' do
      request_hash = get_hash(request)
      return 400 if request_hash.nil?
      return 404 if request_hash[:return_id].nil? || request_hash[:return_data].nil?

      @use_case_factory.get_use_case(:soft_update_return).execute(
        return_id: request_hash[:return_id], return_data: request_hash[:return_data]
      )

      200
    end

    post '/return/create' do
      request_hash = get_hash(request)
      return 400 if request_hash.nil?

      return_id = @use_case_factory.get_use_case(:create_return).execute(
        project_id: request_hash[:project_id],
        data: request_hash[:data]
      )

      response.tap do |r|
        r.body = { id: return_id[:id] }.to_json
        r.status = 201
      end
    end

    post '/return/submit' do
      request_hash = get_hash(request)
      return 400 if request_hash.nil?

      @use_case_factory.get_use_case(:submit_return).execute(
        return_id: request_hash[:return_id].to_i
      )

      response.status = 200
    end

    def get_hash(request)
      body = request.body.read
      return nil if body.to_s.empty?
      request_json = JSON.parse(body)
      Common::DeepSymbolizeKeys.to_symbolized_hash(request_json)
    end

    get '/return/get' do
      return 400 if params['id'].nil?
      return_id = params['id'].to_i

      return_hash = @use_case_factory.get_use_case(:get_return).execute(id: return_id)

      return 404 if return_hash.empty?

      return_schema = @use_case_factory
        .get_use_case(:get_schema_for_return)
        .execute(return_id: return_id)[:schema]

      response.body = {
        project_id: return_hash[:project_id],
        data: return_hash[:updates].last,
        status: return_hash[:status],
        schema: return_schema
      }.to_json

      response.status = 200
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

    get '/project/:id/returns' do
      returns = @use_case_factory.get_use_case(:get_returns).execute(project_id: params['id'].to_i)
      response.status = returns.empty? ? 404 : 200
      response.body = returns.to_json
    end

    get '/project/find' do
      return 404 if params['id'].nil?

      project = @use_case_factory.get_use_case(:find_project).execute(id: params['id'].to_i)

      return 404 if project.nil?

      schema = @use_case_factory.get_use_case(:get_schema_for_project).execute(type: project[:type])[:schema]

      content_type 'application/json'
      response.body = {
        type: project[:type],
        data: Common::DeepCamelizeKeys.to_camelized_hash(project[:data]),
        schema: schema
      }.to_json
      response.status = 200
    end

    post '/project/create' do
      request_hash = get_hash(request)

      use_case = @use_case_factory.get_use_case(:create_new_project)

      id = use_case.execute(
        type: request_hash[:type],
        baseline: Common::DeepSymbolizeKeys.to_symbolized_hash(request_hash[:baselineData])
      )

      content_type 'application/json'
      response.body = {
        projectId: id
      }.to_json
      response.status = 201
    end

    post '/project/update' do
      request_hash = get_hash(request)

      if valid_update_request_body(request_hash)
        use_case = @use_case_factory.get_use_case(:update_project)
        update_successful = use_case.execute(
          id: request_hash[:id].to_i,
          project: {
            type: request_hash[:project][:type],
            baseline: request_hash[:project][:baselineData]
          }
        )[:successful]
        response.status = update_successful ? 200 : 404
      else
        response.status = 400
      end
    end

    private

    def valid_update_request_body(request_body)
      !request_body.dig(:id).nil? &&
        !request_body.dig(:project, :type).nil? &&
        !request_body.dig(:project, :baselineData).nil?
    end
  end
end
