# frozen_string_literal: true

describe LocalAuthority::UseCase::CreateAccessToken do
  let(:access_token_gateway_spy) { spy }
  let(:use_case) { described_class.new(access_token_gateway: access_token_gateway_spy).execute(project_id: 1, email: 'dog@doghouse.com') }
  it 'should create a access token' do
    expect(use_case[:access_token].length).to eq(36)
    expect(use_case[:access_token].class).to eq(String)
  end

  it 'returns different access token' do
    expect(described_class.new(access_token_gateway: access_token_gateway_spy).execute(project_id: 1, email: 'cat@cathouse.com')).not_to(
      eq(described_class.new(access_token_gateway: access_token_gateway_spy).execute(project_id: 1, email: 'dog@doghouse.com')))
  end

  it 'saves the Access Token to the gateway' do
    use_case
    expect(access_token_gateway_spy).to have_received(:create) do |arg|
      expect(arg.uuid.length).to eq(36)
      expect(arg.uuid.class).to eq(String)
      expect(arg.project_id).to eq(1)
      expect(arg.email).to eq('dog@doghouse.com')
    end
  end
end
