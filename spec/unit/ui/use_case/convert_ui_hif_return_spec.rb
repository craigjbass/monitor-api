describe UI::UseCase::ConvertUIHIFReturn do
  let(:return_to_convert) do
    JSON.parse(
      File.open("#{__dir__}/../../../fixtures/hif_return_ui.json").read,
      symbolize_names: true
    )
  end

  let(:core_data_return) do
    JSON.parse(
      File.open("#{__dir__}/../../../fixtures/hif_return_core.json").read,
      symbolize_names: true
    )
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(return_data: return_to_convert)

    expect(converted_project[:fundingPackages]).to eq(core_data_return[:fundingPackages])
  end
end
