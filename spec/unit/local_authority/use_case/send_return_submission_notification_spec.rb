describe LocalAuthority::UseCase::SendReturnSubmissionNotification do
  let(:email_notification_gateway_spy) { spy }

  let(:use_case) do
    described_class.new(email_notification_gateway: email_notification_gateway_spy)
  end

  context 'calls the email notification gateway' do
    example 'example 1' do
      use_case.execute(email: 'cat@cathouse.com', url: 'example.com')
      expect(email_notification_gateway_spy).to have_received(:send_return_notification).with(to: 'cat@cathouse.com', url: 'example.com')
    end

    example 'example 2' do
      use_case.execute(email: 'dog@doghouse.com', url: 'example.net')
      expect(email_notification_gateway_spy).to have_received(:send_return_notification).with(to: 'dog@doghouse.com', url: 'example.net')
    end
  end
end
