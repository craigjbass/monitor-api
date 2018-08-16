require 'notifications/client'
class LocalAuthority::Gateway::GovEmailNotificationGateway

  def initialize
      @client = Notifications::Client.new(ENV.fetch('GOV_NOTIFY_API_KEY'))
  end

  def send_notification(to:,url:)

     @client.send_email(email_address: to, personalisation:{access_url:url})
  end
end
