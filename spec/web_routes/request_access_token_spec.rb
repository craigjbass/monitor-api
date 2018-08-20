# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'requesting an access token' do
  let(:notification_gateway_spy) { spy }
  let(:check_email_spy) { spy(execute: { valid: true }) }
  let(:send_notification_spy) { spy }
  let(:valid_email) { 'cats@meow.com' }

  before do
    stub_const(
      'LocalAuthority::UseCase::CheckEmail',
      double(new: check_email_spy)
    )

    stub_const(
      'LocalAuthority::Gateway::InMemoryApiKeyGateway',
      double(new: nil)
    )

    stub_const(
      'LocalAuthority::UseCase::SendNotification',
      double(new: send_notification_spy)
    )

    stub_const(
      'LocalAuthority::Gateway::GovEmailNotificationGateway',
      double(new: notification_gateway_spy)
    )
  end

  before do
    ENV['EMAIL_WHITELIST'] = 'cats@meow.com'
    post '/token/request', { email_address: valid_email, url: 'http://catscatscats.cat' }.to_json
  end

  it 'checks email address' do
    expect(check_email_spy).to have_received(:execute).with(email_address: valid_email)
  end

  context 'given a valid email address' do
    it 'returns a 200' do
      expect(last_response.status).to eq(200)
    end

    it 'passes email address and url to send notification use case' do
      expect(send_notification_spy).to have_received(:execute).with(to: valid_email, url: 'http://catscatscats.cat')
    end
  end

  context 'given an invalid email address' do
    let(:check_email_spy) { spy(execute: { valid: false }) }
    before do
      post '/token/request', { email_address: 'not@valid.com', url: 'http://catscatscats.cat' }.to_json
    end

    it 'returns a 200' do
      expect(last_response.status).to eq(200)
    end

    it 'does not pass email address and url to send notification use case' do
      expect(send_notification_spy).to_not have_received(:execute).with(to: valid_email, url: 'http://catscatscats.cat')
    end
  end
end
