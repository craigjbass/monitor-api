# frozen_string_literal: true

class LocalAuthority::UseCase::GetBaseReturn
  def initialize(return_gateway:, project_gateway:)
    @return_gateway = return_gateway
    @project_gateway = project_gateway
  end

  def execute(project_id:)
    project = @project_gateway.find_by(id: project_id)
    schema = @return_gateway.find_by(type: project.type)

    { base_return: { id: project_id, data: project.data, schema:schema.schema } }
  end
end
