class HomesEngland::UseCase::UpdateProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:, project_data:)
    current_project = @project_gateway.find_by(id: project_id)
    current_project.data = project_data
    current_project.status = 'Draft'

    successful = @project_gateway.update(id: project_id, project: current_project)[:success]

    { successful: successful }
  end
end
