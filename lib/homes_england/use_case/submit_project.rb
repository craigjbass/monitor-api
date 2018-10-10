class HomesEngland::UseCase::SubmitProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:)
    @project_gateway.submit(id: project_id)
  end
end
