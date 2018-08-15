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
      ENV['EMAIL_WHITELIST']= "#{valid_email}"
    end

    it 'should create a GUID' do

      pp get_use_case(:check_email).execute(email_address: valid_email)
      expect(is_valid_email).to eq(true)
      guid = get_use_case(:create_guid).execute[:guid]
      expect(guid.class).to eq(String)
      expect(guid.length).to eq(36)
      expend_status = get_use_case(:expend_guid).execute(guid: guid)[:status]
      expect(expend_status).to eq(:success)
    end
  end
end
