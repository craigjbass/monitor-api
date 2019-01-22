
class UI::UseCase::ConvertCoreProject 
  def initialize(convert_core_hif_project:, convert_core_ac_project:)
    @convert_core_hif_project = convert_core_hif_project
    @convert_core_ac_project = convert_core_ac_project
  end

  def execute(project_data:, type: nil)
    return @convert_core_hif_project.execute(project_data: project_data) if type == 'hif'
    return @convert_core_ac_project.execute(project_data: project_data) if type == 'ac'

    project_data
  end
end