# frozen_string_literal: true

class UI::UseCase::CreateReturn
  def initialize(create_return:, find_project:, convert_ui_return:)
    @create_return = create_return
    @find_project = find_project
    @convert_ui_return = convert_ui_return
  end

  def execute(project_id:, data:)
    type = @find_project.execute(id: project_id)[:type]
    
    data = @convert_ui_return.execute(return_data: data, type: type)

    return_id = @create_return.execute(project_id: project_id, data: data)[:id]

    { id: return_id }
  end
end
