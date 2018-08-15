# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Creates a token' do
  include_context 'use case factory'

  let(:valid_email) { 'hello@world.com' }

  let(:is_valid_email) do
    get_use_case(:check_email).execute(email_address: valid_email)[:valid]
  end

  context 'with a valid email address' do
    before do
      ENV['EMAIL_WHITELIST'] = valid_email.to_s
    end

    it 'should create an Access Token' do
      pp get_use_case(:check_email).execute(email_address: valid_email)
      expect(is_valid_email).to eq(true)
      access_token = get_use_case(:create_access_token).execute[:access_token]
      expect(access_token.class).to eq(String)
      expect(access_token.length).to eq(36)
      expend_status = get_use_case(:expend_access_token).execute(access_token: access_token)[:status]
      expect(expend_status).to eq(:success)
    end
  end
end
