class LocalAuthority::UseCase::GetSchemaForReturn
  def initialize(project_gateway:, return_gateway:, template_gateway:)
    @project_gateway = project_gateway
    @return_gateway = return_gateway
    @template_gateway = template_gateway
  end

  def execute(return_id:)
    found_return = @return_gateway.find_by(id: return_id)
    project = @project_gateway.find_by(id: found_return.project_id)
    template = @template_gateway.find_by(type: project.type)

    {
      schema: template.schema
    }
  end
end

