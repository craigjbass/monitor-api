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

  it 'will delete the s151 section if the ENV variable is set to nil' do
    expect_no_tab_for('S151', 's151')
  end

  it 'will delete the s151 confirmation section if the ENV variable is set to nil' do
    expect_no_tab_for('CONFIRMATION', 's151Confirmation')
  end

  it 'will delete the outputs forcast section if the env variable is set to nil' do
    expect_no_tab_for('OUTPUTS_FORECAST', 'outputsForecast')
  end

  it 'will delete the outputs actuals section if the env variable is set to nil' do
    expect_no_tab_for('OUTPUTS_ACTUALS', 'outputsActuals')
  end

  it 'will delete the rm monthly catchup if the env variables is set to nil' do
    expect_no_tab_for('RM_MONTHLY_CATCHUP', 'rmMonthlyCatchup')
  end

  it 'will delete the rm monthly catchup if the env variables is set to nil' do
    expect_no_tab_for('WIDER_SCHEME', 'widerScheme')
  end

  private

  def expect_no_tab_for(env_name, section_name)
    allow(ENV).to receive(:[]).and_return(true)

    allow(ENV).to receive(:[]).with("#{env_name}_TAB").and_return(nil)

    gateway = described_class.new
    schema = gateway.find_by(type: 'hif')

    expect(schema.schema[:properties][:"#{section_name}"]).to be_nil
  end
end
