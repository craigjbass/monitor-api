class HomesEngland::UseCase::UpdateProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(id:, project:)
    updated_project = HomesEngland::Domain::Project.new
    updated_project.type = project[:type]
    updated_project.data = project[:baseline]

    successful = @project_gateway.update(id: id, project: updated_project)[:success]

    { successful: successful }
  end
end
