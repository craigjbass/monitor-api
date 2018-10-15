describe LocalAuthority::Gateway::InMemoryReturnTemplate do
  def get_template(type:)
    described_class.new.find_by(type: type)
  end

  it 'returns a template when given type hif' do
    expect(get_template(type: 'hif')).not_to be_nil
  end

  it 'returns nil when not given type hif' do
    expect(get_template(type: 'abc')).to be_nil
  end

  context 'Outputs Forcast Tab' do
    let(:template) { get_template(type: 'hif') }

    it 'Does not contain the outputs forecast tab when disabled' do
      expect(template.schema[:properties]).not_to have_key(:outputsForecast)
    end

    it 'Contains the outputs forecast tab when enabled' do
      ENV['OUTPUTS_FORECAST_TAB'] = 'Yes'

      expect(template.schema[:properties]).to have_key(:outputsForecast)

      ENV['OUTPUTS_FORECAST_TAB'] = nil
    end
  end
end
