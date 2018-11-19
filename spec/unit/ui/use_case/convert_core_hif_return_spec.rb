describe UI::UseCase::ConvertCoreHIFReturn do
  let(:return_to_convert) do
    JSON.parse(
      File.open("#{__dir__}/../../../fixtures/hif_return_core.json").read,
      symbolize_names: true
    )
  end

  let(:ui_data_return) do
    JSON.parse(
      File.open("#{__dir__}/../../../fixtures/hif_return_ui.json").read,
      symbolize_names: true
    )
  end

  it 'Converts the project correctly' do
    converted_return = described_class.new.execute(return_data: return_to_convert)
    expect(converted_return[:fundingPackages]).to eq(ui_data_return[:fundingPackages])

    expect(converted_return).to eq(ui_data_return)
  end
end
