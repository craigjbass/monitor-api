class HomesEngland::UseCase::UpdateProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(id:, project:)
    @project_gateway.update(id: id, project: project)
  end
end
