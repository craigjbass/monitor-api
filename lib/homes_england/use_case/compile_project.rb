class HomesEngland::UseCase::CompileProject
  def initialize(find_project:, get_returns:)
    @find_project = find_project
    @get_returns = get_returns
  end

  def execute(project_id:)
    baseline = @find_project.execute(id: project_id)
    baseline[:project_id] = project_id
    baseline.delete(:status)

    submitted_returns = @get_returns.execute(project_id: project_id)[:returns]
    unless submitted_returns.empty?
      submitted_returns.each do |i|
        i[:data] = i.dig(:updates, -1)
        i.delete(:updates)
        i.delete(:status)
      end
    end

    {
      compiled_project: {
        baseline: baseline,
        submitted_returns: submitted_returns
      }
    }
  end
end
