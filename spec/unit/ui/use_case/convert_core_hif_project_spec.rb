describe UI::UseCase::ConvertCoreHIFProject do
  let(:project_to_convert) do
    JSON.parse(
      File.open("#{__dir__}/../../../fixtures/hif_baseline.json").read,
      symbolize_names: true
    )
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(project_to_convert)

    expect(converted_project).to eq(project_to_convert)
  end
end
