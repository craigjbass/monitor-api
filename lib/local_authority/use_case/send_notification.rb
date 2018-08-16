# frozen_string_literal: true

class LocalAuthority::UseCase::SendNotification
  def initialize(notification_gateway:)
    @notification_gateway = notification_gateway
  end

  def execute(to:, url:)
    @notification_gateway.send_notification(to: to, url: url)
  end
end
