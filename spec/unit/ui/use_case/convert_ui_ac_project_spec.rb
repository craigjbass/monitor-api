describe UI::UseCase::ConvertUIACProject do
  let(:core_data_project) do
    JSON.parse(
      File.open("#{__dir__}/../../../fixtures/ac_baseline_core.json").read,
      symbolize_names: true
    )
  end

  let(:ui_project_to_convert) do
    JSON.parse(
      File.open("#{__dir__}/../../../fixtures/ac_baseline_ui.json").read,
      symbolize_names: true
    )
  end

  it 'Converts the project correctly' do
    converted_project = described_class.new.execute(project_data: ui_project_to_convert)

    expect(converted_project).to eq(core_data_project)
  end
end