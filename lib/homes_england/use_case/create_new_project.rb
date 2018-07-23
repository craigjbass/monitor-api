# frozen_string_literal: true

class HomesEngland::UseCase::CreateNewProject
  def initialize(project_gateway:, populate_template_use_case:)
    @project_gateway = project_gateway
    @populate_template = populate_template_use_case
  end

  def execute(type:, baseline:)

    populated_data = @populate_template.execute(type: type, baseline: baseline)

    project = HomesEngland::Domain::Project.new
    project.type = type
    project.data = populated_data[:populated_data]

    id = @project_gateway.create(project)

    { id: id }
  end
end
