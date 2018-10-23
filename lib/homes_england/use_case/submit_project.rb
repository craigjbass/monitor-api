# frozen_string_literal: true

class HomesEngland::UseCase::SubmitProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:)
    project = @project_gateway.find_by(id: project_id)
    if project.status == 'Draft'
      @project_gateway.submit(id: project_id, status: 'LA Draft')
    elsif project.status == 'LA Draft'
      @project_gateway.submit(id: project_id, status: 'Submitted')
    end
  end
end
