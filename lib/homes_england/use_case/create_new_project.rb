class HomesEngland::UseCase::CreateNewProject

  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(type:, baseline:)
    project = HomesEngland::Domain::Project.new
    project.type = type
    project.data = baseline

    id = @project_gateway.create(project)

    { id: id }
  end
end