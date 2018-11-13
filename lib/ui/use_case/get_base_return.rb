# frozen_string_literal: true

class UI::UseCase::GetBaseReturn
  def initialize(get_base_return:)
    @get_base_return = get_base_return
  end

  def execute(project_id:)
    base_return = @get_base_return.execute(project_id: project_id)[:base_return]

    { base_return: base_return }
  end
end
