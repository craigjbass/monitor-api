# frozen_string_literal: true

class UI::UseCase::GetBaseReturn
  def initialize(get_base_return:, return_schema:, find_project:, convert_core_return:)
    @get_base_return = get_base_return
    @return_schema = return_schema
    @find_project = find_project
    @convert_core_return = convert_core_return
  end

  def execute(project_id:)
    type = @find_project.execute(id: project_id)[:type]

    base_return = @get_base_return.execute(project_id: project_id)[:base_return]

    base_return[:data] = @convert_core_return.execute(return_data: base_return[:data], type: type)
    base_return[:schema] = @return_schema.find_by(type: type).schema

    {
      base_return: base_return
    }
  end
end
