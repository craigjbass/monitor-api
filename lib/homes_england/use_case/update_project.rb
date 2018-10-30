class HomesEngland::UseCase::UpdateProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:, project_data:)
    current_project = @project_gateway.find_by(id: project_id)
    current_project.data = project_data
    if submitted?(current_project) || la_draft?(current_project)
      current_project.status = 'LA Draft'
    else
      current_project.status = 'Draft'
    end

    successful = @project_gateway.update(id: project_id, project: current_project)[:success]

    { successful: successful }
  end

  private

  def submitted?(current_project)
    current_project.status == 'Submitted'
  end

  def la_draft?(current_project)
    current_project.status == 'LA Draft'
  end
end
