# frozen_string_literal: true

class UI::UseCase::GetReturn
  def initialize(get_return:)
    @get_return = get_return
  end

  def execute(id:)
    found_return = @get_return.execute(id: id)

    {
      id: found_return[:id],
      type: found_return[:type],
      project_id: found_return[:project_id],
      status: found_return[:status],
      updates: found_return[:updates]
    }
  end
end
