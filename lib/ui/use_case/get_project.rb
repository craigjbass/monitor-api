# frozen_string_literal: true

class UI::UseCase::GetProject
  def initialize(find_project:, convert_core_hif_project:)
    @find_project = find_project
    @convert_core_hif_project = convert_core_hif_project
  end

  def execute(id:)
    found_project = @find_project.execute(id: id)

    found_project[:data] = convert_data(found_project) unless found_project[:type] != 'hif'

    {
      name: found_project[:name],
      type: found_project[:type],
      data: found_project[:data],
      status: found_project[:status]
    }
  end

  private

  def convert_data(project)
    @convert_core_hif_project.execute(project_data: project[:data])
  end
end
