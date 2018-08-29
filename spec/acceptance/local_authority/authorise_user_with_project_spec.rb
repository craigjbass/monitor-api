# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

xdescribe 'Authorises the user' do
  include_context 'use case factory'

  context 'valid user' do
    let(:valid_email) { 'hello@world.com' }

    let(:is_valid_email) do
      get_use_case(:check_email).execute(email_address: valid_email, project_id: 1)[:valid]
    end

    it 'should create a valid access token for project 1' do
      get_use_case(:add_user).execute(email: valid_email)
      get_use_case(:add_user_to_project).execute(project_id: 1)

      expect(is_valid_email).to eq(true)
      access_token = get_use_case(:create_access_token).execute(project_id: 1)[:access_token]

      expend_status = get_use_case(:expend_access_token).execute(access_token: access_token, project_id: 1)[:status]
      expect(expend_status).to eq(:success)
    end

    it 'should create a valid api key for project 1' do
      api_key = get_use_case(:create_api_key).execute(project_id: 1)[:api_key]

      expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: 1)).to eq(valid: true)
    end
  end

  context 'invalid user' do
    let(:invalid_email) { 'hello@world.com' }

    let(:is_valid_email) do
      get_use_case(:check_email).execute(email_address: invalid_email, project_id: 1)[:valid]
    end

    it 'should be unable to create a valid access token for project 1' do
      expect(is_valid_email).to eq(false)
      access_token = get_use_case(:create_access_token).execute(project_id: 1)[:access_token]

      expend_status = get_use_case(:expend_access_token).execute(access_token: access_token, project_id: 1)[:status]
      expect(expend_status).to eq(:failure)
    end

    it 'should be unable to create a valid api key for project 1' do
      api_key = get_use_case(:create_api_key).execute(project_id: 1)[:api_key]

      expect(get_use_case(:check_api_key).execute(api_key: api_key, project_id: 1)).to eq(valid: false)
    end
  end
end
