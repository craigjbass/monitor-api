class HomesEngland::UseCase::FindProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(id:)
    @project_gateway.find_by(id: id)
  end
end