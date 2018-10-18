class HomesEngland::UseCase::UpdateProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:, project_data:)
    current_project = @project_gateway.find_by(id: project_id)
    updated_project = HomesEngland::Domain::Project.new
    updated_project.data = project_data
    if current_project.status == 'Submitted' || current_project.status == 'LA Draft'
      updated_project.status = 'LA Draft'
    else
      updated_project.status = 'Draft'
    end

    successful = @project_gateway.update(id: project_id, project: updated_project)[:success]

    { successful: successful }
  end
end
