# frozen_string_literal: true

require 'notifications/client'
class LocalAuthority::Gateway::GovEmailNotificationGateway
  def initialize
    @client = Notifications::Client.new(ENV.fetch('GOV_NOTIFY_API_KEY'), base_url=ENV['GOV_NOTIFY_API_URL'])
  end

  def send_notification(to:, url:, access_token:)
    @client.send_email(
      email_address: to,
      template_id: 'b8fc89b6-79c6-491f-9872-60e110130e4a',
      personalisation: { access_url: "#{url}/?token=#{access_token}" }
    )
  end

  def send_return_notification(to:, url:, by:, project_name:)
    @client.send_email(
      email_address: to,
      template_id: 'c5876716-e0b3-4089-9ee1-040a0a2807dc',
      personalisation: { access_url: url, by: by, project_name: project_name }
    )
  end
end
