# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Authorises the user' do
  include_context 'dependency factory'

  before { ENV['HMAC_SECRET'] = 'Meow' }

  after { get_gateway(:access_token).clear }

  context 'Correct access token for project' do
    it 'should create a valid access token for project 1' do
      access_token = get_use_case(:create_access_token).execute(project_id: 1)[:access_token]

      expend_status = get_use_case(:expend_access_token).execute(access_token: access_token, project_id: 1)[:status]
      expect(expend_status).to eq(:success)
    end

    it 'should create a valid api key for project 1' do
      api_key = get_use_case(:create_api_key).execute(project_id: 1)[:api_key]
      expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: 1)).to eq(valid: true)
    end
  end

  context 'Incorrect access token for project' do
    it 'Should not expend the access token' do
      access_token = get_use_case(:create_access_token).execute(project_id: 1)[:access_token]

      expend_status = get_use_case(:expend_access_token).execute(access_token: access_token, project_id: 2)[:status]
      expect(expend_status).to eq(:failure)
    end
  end
end
