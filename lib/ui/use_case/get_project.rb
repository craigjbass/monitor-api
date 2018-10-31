# frozen_string_literal: true

class UI::UseCase::GetProject
  def initialize(find_project:)
    @find_project = find_project
  end

  def execute(id:)
    found_project = @find_project.execute(id: id)

    {
      name: found_project[:name],
      type: found_project[:type],
      data: found_project[:data],
      status: found_project[:status]
    }
  end
end
