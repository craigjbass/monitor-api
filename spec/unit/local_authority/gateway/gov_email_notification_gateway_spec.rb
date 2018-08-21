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
        described_class.new.send_notification(to: 'cat@cathouse.com', url: 'http://cats.com', access_token: 'CatAccess')
        expect(send_mail_spy).to have_received(:send_email) do |args|
          expect(args[:email_address]).to eq('cat@cathouse.com')
          expect(args[:personalisation]).to eq(access_url: 'http://cats.com' + '/?token=CatAccess')
        end
      end
    end
  end

  context 'example 2' do
    context 'given email address and url' do
      it 'will run send_email with address and url within personalisation hash' do
        described_class.new.send_notification(to: 'dog@doghouse.com', url: 'http://dogs.com', access_token: 'DogAccess')
        expect(send_mail_spy).to have_received(:send_email) do |args|
          expect(args[:email_address]).to eq('dog@doghouse.com')
          expect(args[:personalisation]).to eq(access_url: 'http://dogs.com' + '/?token=DogAccess')
        end
      end
    end
  end
end
