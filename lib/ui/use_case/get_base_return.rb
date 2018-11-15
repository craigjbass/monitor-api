# frozen_string_literal: true

class UI::UseCase::GetBaseReturn
  def initialize(get_base_return:, find_project:, convert_core_hif_return:)
    @get_base_return = get_base_return
    @find_project = find_project
    @convert_core_hif_return = convert_core_hif_return
  end

  def execute(project_id:)
    type = @find_project.execute(id: project_id)[:type]

    base_return = @get_base_return.execute(project_id: project_id)[:base_return]

    base_return[:data] = @convert_core_hif_return.execute(return_data: base_return[:data]) if type == 'hif'
    { base_return: base_return }
  end
end
