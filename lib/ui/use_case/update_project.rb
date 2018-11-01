# frozen_string_literal: true

class UI::UseCase::UpdateProject
  def initialize(update_project:)
    @update_project = update_project
  end

  def execute(id:, data:)
    successful = @update_project.execute(
      project_id: id,
      project_data: data
    )[:successful]

    { successful: successful }
  end
end
