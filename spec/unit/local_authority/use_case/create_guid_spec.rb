# frozen_string_literal: true

describe LocalAuthority::UseCase::CreateGUID do
  let(:use_case) { described_class.new.execute }
  it 'should create a guid' do
    expect(use_case[:guid].length).to eq(36)
    expect(use_case[:guid].class).to eq(String)
  end

  it 'returns different guids' do
    expect(described_class.new.execute).not_to eq(described_class.new.execute)
  end
end
