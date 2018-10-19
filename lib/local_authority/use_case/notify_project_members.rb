class LocalAuthority::UseCase::NotifyProjectMembers
  def initialize(send_return_submission_notification:, get_project_users:)
    @get_project_users = get_project_users
    @send_return_submission_notification = send_return_submission_notification
  end

  def execute(project_id:, url:, by:, project_name:)
    emails = @get_project_users.execute(project_id: project_id)[:users]
    emails.each do |email|
      @send_return_submission_notification.execute(email: email, url: url, by: by, project_name: project_name)
    end
  end
end
