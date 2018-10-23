# frozen_string_literal: true

class HomesEngland::UseCase::CreateNewProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(type:, baseline:)
    project = HomesEngland::Domain::Project.new
    project.type = type
    project.data = baseline
    project.status = 'Draft'

    id = @project_gateway.create(project)

    { id: id }
  end
end
