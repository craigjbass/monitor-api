class HomesEngland::UseCase::UpdateProject
  def initialize(project_gateway:)
    @project_gateway = project_gateway
  end

  def execute(project_id:, project_data:, timestamp:)
    current_project = @project_gateway.find_by(id: project_id)

    return { successful: false, errors: [:incorrect_timestamp], timestamp: timestamp } unless valid_timestamps?(current_project.timestamp, timestamp)
    current_time = Time.now.to_i
    current_project.data = project_data
    current_project.status = 'Draft'
    current_project.timestamp = current_time

    successful = @project_gateway.update(id: project_id, project: current_project)[:success]

    { successful: successful, errors: [], timestamp:  current_time}
  end

  private

  def valid_timestamps?(saved_timestamp, new_timestamp)
    saved_timestamp == new_timestamp || saved_timestamp.zero?
  end
end
