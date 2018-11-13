class UI::UseCase::GetReturns
  def initialize(get_returns:)
    @get_returns = get_returns
  end

  def execute(project_id:)
    found_returns = @get_returns.execute(project_id: project_id)[:returns]

    { returns: found_returns }
  end
end