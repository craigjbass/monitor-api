# frozen_string_literal: true

require 'notifications/client'
class LocalAuthority::Gateway::GovEmailNotificationGateway
  def initialize
    @client = Notifications::Client.new(ENV.fetch('GOV_NOTIFY_API_KEY'))
    @default_template = 'b8fc89b6-79c6-491f-9872-60e110130e4a'
  end

  def send_notification(to:, url:, access_token:)
    @client.send_email(
      email_address: to,
      template_id: @default_template,
      personalisation: { access_url: url + "/?token=#{access_token}" }
    )
  end
end
