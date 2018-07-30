# frozen_string_literal: true

class LocalAuthority::UseCase::GetBaseReturn
  def initialize(populate_return:, project_gateway:)
    @populate_return = populate_return
    @project_gateway = project_gateway
  end

  def execute(project_id:)
    project = @project_gateway.find_by(id: project_id)
    return_data = @populate_return.execute(
      type: project.type, data: project.data
    )[:populated_data]

    { base_return: return_data }
  end
end
