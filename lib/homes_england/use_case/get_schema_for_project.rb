class HomesEngland::UseCase::GetSchemaForProject
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:)
    template = @template_gateway.get_template(type: type)
    p template

    { schema: template.schema }
  end
end
