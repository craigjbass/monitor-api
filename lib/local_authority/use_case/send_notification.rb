# frozen_string_literal: true

class LocalAuthority::UseCase::SendNotification
  def initialize(notification_gateway:)
    @notification_gateway = notification_gateway
  end

  def execute(to:, url:, access_token:)
    @notification_gateway.send_notification(to: to, url: url, access_token: access_token)
  end
end
