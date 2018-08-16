# frozen_string_literal: true

describe LocalAuthority::Gateway::GovEmailNotificationGateway do
  let(:send_mail_spy) do
    spy(send_email: {})
  end

  before do
    stub_const(
      'Notifications::Client',
      double(new: send_mail_spy)
    )

    stub_const(
      'ENV',
      double(fetch: nil)
    )
  end

  context 'example 1' do
    context 'given email address and url' do
      it 'will run send_email with address and url within personalisation hash' do
        described_class.new.send_notification(to: 'cat@cathouse.com', url: 'http://cats.com')
        expect(send_mail_spy).to have_received(:send_email).with(email_address: 'cat@cathouse.com',
                                                                 personalisation:
                                                                   { access_url: 'http://cats.com' })
      end
    end
  end

  context 'example 2' do
    context 'given email address and url' do
      it 'will run send_email with address and url within personalisation hash' do
        described_class.new.send_notification(to: 'dog@doghouse.com', url: 'http://dogs.com')
        expect(send_mail_spy).to have_received(:send_email).with(email_address: 'dog@doghouse.com',
                                                                 personalisation:
                                                                   { access_url: 'http://dogs.com' })
      end
    end
  end
end
