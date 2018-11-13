class HomesEngland::UseCase::ExportProjectData
  def initialize(find_project:, get_returns:)
    @find_project = find_project
    @get_returns = get_returns
  end

  def execute(project_id:)
    baseline_data = @find_project.execute(id: project_id)
    new_baseline = format_baseline_data(baseline_data, project_id)

    all_returns = @get_returns.execute(project_id: project_id)[:returns]
    unless all_returns.empty?
      submitted_returns = get_submitted_returns(all_returns)
      formatted_returns = submitted_returns.map do |return_data|
        format_return_data(return_data)
      end
    end

    {
      compiled_project: {
        baseline: new_baseline,
        submitted_returns: formatted_returns
      }
    }
  end

  def get_submitted_returns(returns)
    returns.reject do |return_data|
      return_data[:status] == 'Draft'
    end
  end

  def format_baseline_data(baseline_data, project_id)
    {
      project_id: project_id,
      name: baseline_data[:name],
      type: baseline_data[:type],
      data: baseline_data[:data]
    }
  end

  def format_return_data(return_data)
    {
      id: return_data[:id],
      project_id: return_data[:project_id],
      data: return_data.dig(:updates, -1)
    }
  end
end
