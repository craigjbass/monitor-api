require 'rspec'

describe HomesEngland::Gateway::InMemoryTemplate do
  it 'returns nil when given a non-hif type' do
    template = described_class.new.get_template(type: 'abc')
    expect(template).to be_nil
  end

  it 'returns a template given a hif type' do
    template = described_class.new.get_template(type: 'hif')
    expect(template).not_to be_nil
  end
end
