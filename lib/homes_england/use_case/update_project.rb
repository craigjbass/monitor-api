class HomesEngland::UseCase::UpdateProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:, project_data:)
    updated_project = HomesEngland::Domain::Project.new
    updated_project.data = project_data
    updated_project.status = 'Draft'

    successful = @project_gateway.update(id: project_id, project: updated_project)[:success]

    { successful: successful }
  end
end
