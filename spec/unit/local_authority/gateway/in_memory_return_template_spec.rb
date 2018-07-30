describe LocalAuthority::Gateway::InMemoryReturnTemplate do
  it 'returns a template when given type hif' do
    template = described_class.new.find_by(type: 'hif')
    expect(template).not_to be_nil
  end

  it 'returns nil when not given type hif' do
    template = described_class.new.find_by(type: 'abc')
    expect(template).to be_nil
  end
end
