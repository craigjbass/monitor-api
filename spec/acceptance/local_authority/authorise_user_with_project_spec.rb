# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Authorises the user' do
  include_context 'dependency factory'

  before do
    ENV['HMAC_SECRET'] = 'Meow'

    get_use_case(:add_user).execute(email: 'cat@cathouse.com', role: 'HomesEngland')
    get_use_case(:add_user_to_project).execute(project_id: 1, email: 'cat@cathouse.com')
  end

  after { get_gateway(:access_token).clear }

  context 'Correct access token for project' do
    it 'should create a valid access token for project 1' do
      access_token = get_use_case(:create_access_token).execute(project_id: 1, email: 'cat@cathouse.com')[:access_token]

      expend_result = get_use_case(:expend_access_token).execute(access_token: access_token, project_id: 1)
      expect(expend_result[:status]).to eq(:success)
      expect(expend_result[:role]).to eq('HomesEngland')
    end

    it 'should create a valid api key for project 1' do
      api_key = get_use_case(:create_api_key).execute(project_id: 1, email: 'cat@cathouse.com', role: 'HomesEngland')[:api_key]
      expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: 1)).to eq(valid: true, email: 'cat@cathouse.com', role: 'HomesEngland')
    end
  end

  context 'Incorrect access token for project' do
    it 'Should not expend the access token' do
      access_token = get_use_case(:create_access_token).execute(project_id: 1, email: 'cat@cathouse.com')[:access_token]

      expend_status = get_use_case(:expend_access_token).execute(access_token: access_token, project_id: 2)[:status]
      expect(expend_status).to eq(:failure)
    end
  end
end
