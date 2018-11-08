class UI::UseCase::GetReturns
  def initialize(get_returns:, find_project:, convert_core_hif_return:)
    @get_returns = get_returns
    @find_project = find_project
    @convert_core_hif_return = convert_core_hif_return
  end

  def execute(project_id:)
    found_returns = @get_returns.execute(project_id: project_id)[:returns]

    if @find_project.execute(id: project_id)[:type] == 'hif'
      found_returns = found_returns.map do |found_return|
        @convert_core_hif_return.execute(return_data: found_return)
      end
    end

    { returns: found_returns }
  end
end
