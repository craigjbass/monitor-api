# frozen_string_literal: true

class UI::UseCase::ConvertUIProject 
  def initialize(convert_ui_hif_project:, convert_ui_ac_project:)
    @convert_ui_hif_project = convert_ui_hif_project
    @convert_ui_ac_project = convert_ui_ac_project
  end

  def execute(project_data:, type: nil)
    return @convert_ui_hif_project.execute(project_data: project_data) if type == 'hif'
    return @convert_ui_ac_project.execute(project_data: project_data) if type == 'ac'

    project_data
  end
end