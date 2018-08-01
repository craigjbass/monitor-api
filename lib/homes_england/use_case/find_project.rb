class HomesEngland::UseCase::FindProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(id:)
    project = @project_gateway.find_by(id: id)
    {
      type: project.type,
      data: project.data
    }
  end
end

