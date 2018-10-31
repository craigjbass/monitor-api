# frozen_string_literal: true

class UI::UseCase::CreateReturn
  def initialize(create_return:)
    @create_return = create_return
  end

  def execute(project_id:, data:)
    return_id = @create_return.execute(project_id: project_id, data: data)[:id]

    { id: return_id }
  end
end
