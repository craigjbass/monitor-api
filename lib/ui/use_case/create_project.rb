# frozen_string_literal: true

class UI::UseCase::CreateProject
  def initialize(create_project:, convert_ui_hif_project:)
    @create_project = create_project
    @convert_ui_hif_project = convert_ui_hif_project
  end

  def execute(type:, name:, baseline:)
    baseline = convert_baseline(baseline) if type == 'hif'
    created_id = @create_project.execute(
      type: type,
      name: name,
      baseline: baseline
    )[:id]

    { id: created_id }
  end

  private

  def convert_baseline(baseline)
    @convert_ui_hif_project.execute(project_data: baseline)
  end
end
