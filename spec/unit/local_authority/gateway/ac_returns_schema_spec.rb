# frozen_string_literal: true

describe LocalAuthority::Gateway::ACReturnsSchemaTemplate do
  let(:template) { described_class.new.execute }

  it 'returns a schema' do
    expect(template.schema).not_to be_nil
  end
end
