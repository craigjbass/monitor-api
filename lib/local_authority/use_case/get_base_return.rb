# frozen_string_literal: true

class LocalAuthority::UseCase::GetBaseReturn
  def initialize(return_gateway:, project_gateway:, populate_return_template:)
    @return_gateway = return_gateway
    @project_gateway = project_gateway
    @populate_return_template = populate_return_template
  end

  def execute(project_id:)
    project = @project_gateway.find_by(id: project_id)
    schema = @return_gateway.find_by(type: project.type)
    data = project.data
    if project.type == 'hif'
      return_template_populator = @populate_return_template
      data = return_template_populator.execute(type: 'hif', baseline_data: project.data)[:populated_data]
    end

    { base_return: { id: project_id, data: data, schema: schema.schema } }
  end
end
