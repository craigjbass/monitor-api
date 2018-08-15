# frozen_string_literal: true

describe LocalAuthority::UseCase::CreateAndSaveGUID do
  let(:guid_gateway_spy) { spy  }
  let(:use_case) { described_class.new(guid_gateway: guid_gateway_spy).execute }
  it 'should create a guid' do
    expect(use_case[:guid].length).to eq(36)
    expect(use_case[:guid].class).to eq(String)
  end

  it 'returns different guids' do
    expect(described_class.new(guid_gateway: guid_gateway_spy).execute).not_to(
      eq(described_class.new(guid_gateway: guid_gateway_spy).execute))
  end

  it 'saves the guid to the gateway' do
    use_case
    expect(guid_gateway_spy).to have_received(:save) do |arg|
      expect(arg[:guid].length).to eq(36)
      expect(arg[:guid].class).to eq(String)
    end
  end
end
