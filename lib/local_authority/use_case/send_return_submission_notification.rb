class LocalAuthority::UseCase::SendReturnSubmissionNotification
  def initialize(email_notification_gateway:)
    @email_notification_gateway = email_notification_gateway
  end

  def execute(email:, url:)
    @email_notification_gateway.send_return_notification(to: email, url: url)
  end
end
