# frozen_string_literal: true

class UI::UseCase::UpdateProject
  def initialize(update_project:, convert_ui_hif_project:)
    @update_project = update_project
    @convert_ui_hif_project = convert_ui_hif_project
  end

  def execute(id:, data:, type: nil)
    data = convert_data(data) if type == 'hif'
    
    successful = @update_project.execute(
      project_id: id,
      project_data: data
    )[:successful]

    { successful: successful }
  end

  private

  def convert_data(data)
    @convert_ui_hif_project.execute(project_data: data)
  end
end
