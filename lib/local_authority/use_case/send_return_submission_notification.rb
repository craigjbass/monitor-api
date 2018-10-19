class LocalAuthority::UseCase::SendReturnSubmissionNotification
  def initialize(email_notification_gateway:)
    @email_notification_gateway = email_notification_gateway
  end

  def execute(email:, url:, by:, name:)
    @email_notification_gateway.send_return_notification(to: email,
      url: url,
      by: by,
      project_name: name
    )
  end
end
