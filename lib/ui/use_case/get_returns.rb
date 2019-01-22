class UI::UseCase::GetReturns
  def initialize(get_returns:, find_project:, convert_core_return:)
    @get_returns = get_returns
    @find_project = find_project
    @convert_core_return = convert_core_return
  end

  def execute(project_id:)
    found_returns = @get_returns.execute(project_id: project_id)[:returns]
    type = @find_project.execute(id: project_id)[:type]

    found_returns = found_returns.map do |found_return|
      found_return[:updates].map! do |update|
        @convert_core_return.execute(return_data: update, type: type)
      end
      found_return
    end

    { returns: found_returns }
  end
end
