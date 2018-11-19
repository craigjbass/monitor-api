class HomesEngland::UseCase::NotifyProjectMembersOfCreation
  def initialize(send_project_creation_notification:, get_project_users:)
    @get_project_users = get_project_users
    @send_project_creation_notification = send_project_creation_notification
  end

  def execute(project_id:, url:)
    emails = @get_project_users.execute(project_id: project_id)[:users]
    emails.each do |email|
      @send_project_creation_notification.execute(email: email, url: url)
    end
  end
end
