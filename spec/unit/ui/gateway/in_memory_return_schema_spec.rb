# frozen_string_literal: true

describe UI::Gateway::InMemoryReturnSchema do
  it 'Returns a schema when finding by type hif' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'hif')
    expect(schema).not_to be_nil
  end

  it 'Returns nil when searching for a non existing type' do
    gateway = described_class.new
    schema = gateway.find_by(type: 'cats 4 lyf')
    expect(schema).to be_nil
  end
end
