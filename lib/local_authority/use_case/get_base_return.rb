# frozen_string_literal: true

class LocalAuthority::UseCase::GetBaseReturn
  def initialize(return_gateway:, project_gateway:, populate_return_template:, get_returns:)
    @return_gateway = return_gateway
    @project_gateway = project_gateway
    @populate_return_template = populate_return_template
    @get_returns = get_returns
  end

  def execute(project_id:)
    return_data = @get_returns.execute(project_id: project_id).dig(:returns, -1, :updates, -1)
    project = @project_gateway.find_by(id: project_id)
    schema = @return_gateway.find_by(type: project.type)
    if return_data.nil?
      data = @populate_return_template.execute(type: project.type,
        baseline_data: project.data)[:populated_data]
    else
      data = @populate_return_template.execute(type: project.type,
        baseline_data: project.data, return_data: return_data)[:populated_data]
    end

    { base_return: { id: project_id, data: data, schema: schema.schema } }
  end
end
