# frozen_string_literal: true

class LocalAuthority::UseCase::SendNotification
  def initialize(notification_gateway:)
    @notification_gateway = notification_gateway
  end

  def execute(to:, url:, access_token:)
    url_to_send = remove_trailing_slash_and_query_parameters(url)
    @notification_gateway.send_notification(
      to: to,
      url: url_to_send,
      access_token: access_token
    )
  end

  private

  def remove_trailing_slash_and_query_parameters(url)
    optional_slash = %r{/?}
    query_parameters = /\?.*/
    trailing_slash_regex = %r{/$}
    url.gsub(/#{optional_slash}#{query_parameters}|#{trailing_slash_regex}/, '')
  end
end
