# frozen_string_literal: true

class LocalAuthority::UseCase::SendNotification
  def initialize(notification_gateway:)
    @notification_gateway = notification_gateway
  end

  def execute(to:, url:, access_token:)
    url_to_send = url.gsub(/\/?\?.*/, '') #Removes URL params and forward slash prefix if present
    @notification_gateway.send_notification(to: to, url: url_to_send, access_token: access_token)
  end
end
