class HomesEngland::UseCase::ExportAllProjects
  def initialize(project_gateway:, export_project:)
    @project_gateway = project_gateway
    @export_project = export_project
  end

  def execute
    {
      compiled_projects: @project_gateway.all.map do |project|
        @export_project.execute(project_id: project.id)[:compiled_project]
      end
    }
  end
end
