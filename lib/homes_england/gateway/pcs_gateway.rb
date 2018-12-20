class HomesEngland::Gateway::Pcs
  def initialize
    @pcs_url = ENV['PCS_URL']
  end

  def get_project(project_id:)
    received_project = request_project(project_id)

    HomesEngland::Domain::PcsProject.new.tap do |project|
      project.project_manager = received_project["ProjectManager"]
      project.sponsor = received_project["Sponsor"]
    end
  end

  def request_project(project_id)
    response = Net::HTTP.get(@pcs_url,"/project/#{project_id}")
    received_json = JSON.parse(response)
  end
end
