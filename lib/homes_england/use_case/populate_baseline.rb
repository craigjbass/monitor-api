class HomesEngland::UseCase::PopulateBaselineSpec
  def initialize(find_project:, pcs_gateway:)
    @pcs_gateway = pcs_gateway
    @find_project = find_project
  end

  def execute(project_id:)
    pcs_data = @pcs_gateway.get_project(project_id: project_id)
    project_data = @find_project.execute(id: project_id)

    project_data[:data][:summary] = {} if project_data[:data][:summary].nil?
    
    project_data[:data][:summary][:ProjectManager] = pcs_data.project_manager
    project_data[:data][:summary][:Sponsor] = pcs_data.sponsor

    project_data
  end
end
