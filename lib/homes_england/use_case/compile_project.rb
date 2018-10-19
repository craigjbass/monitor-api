class HomesEngland::UseCase::CompileProject
  def initialize(find_project:, get_returns:)
    @find_project = find_project
    @get_returns = get_returns
  end

  def execute(project_id:)
    baseline_data = @find_project.execute(id: project_id)
    new_baseline = format_baseline_data(baseline_data, project_id)

    submitted_returns = @get_returns.execute(project_id: project_id)[:returns]
    unless submitted_returns.empty?
      new_submitted_returns = submitted_returns.map do |return_data|
        format_return_data(return_data)
      end
    end

    {
      compiled_project: {
        baseline: new_baseline,
        submitted_returns: new_submitted_returns
      }
    }
  end

  def format_baseline_data(baseline_data, project_id)
    new_baseline_data = baseline_data.dup
    new_baseline_data[:project_id] = project_id
    new_baseline_data.delete(:status)
    new_baseline_data
  end

  def format_return_data(return_data)
    new_return_data = return_data.dup
    new_return_data[:data] = new_return_data.dig(:updates, -1)
    new_return_data.delete(:updates)
    new_return_data.delete(:status)
    new_return_data
  end
end
