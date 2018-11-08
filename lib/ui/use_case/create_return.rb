# frozen_string_literal: true

class UI::UseCase::CreateReturn
  def initialize(create_return:, find_project:, convert_ui_hif_return:)
    @create_return = create_return
    @find_project = find_project
    @convert_ui_hif_return = convert_ui_hif_return
  end

  def execute(project_id:, data:)
    type = @find_project.execute(id: project_id)[:type]
    puts type
    
    data = @convert_ui_hif_return.execute(return_data: data) if type == 'hif'
    
    return_id = @create_return.execute(project_id: project_id, data: data)[:id]

    { id: return_id }
  end
end
