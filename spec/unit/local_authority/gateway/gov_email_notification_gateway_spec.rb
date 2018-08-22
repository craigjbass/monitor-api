# frozen_string_literal: true

describe LocalAuthority::Gateway::GovEmailNotificationGateway do
  let(:send_mail_spy) do
    spy(send_email: {})
  end

  let(:notifications_client_spy) do
    spy(new: send_mail_spy, meow: 'cat')
  end

  before do
    stub_const(
      'Notifications::Client',
      notifications_client_spy
    )
  end

  context 'example 1' do
    before do
      ENV['GOV_NOTIFY_API_KEY'] = 'superSecret'
      ENV['GOV_NOTIFY_API_URL'] = 'meow.com'
      described_class.new.send_notification(to: 'cat@cathouse.com', url: 'http://cats.com', access_token: 'CatAccess')
    end

    context 'given email address and url' do
      it 'passes the API key and url to the notifications client' do
        expect(notifications_client_spy).to have_received(:new).with('superSecret', 'meow.com')
      end

      it 'will run send_email with address and url within personalisation hash' do
        expect(send_mail_spy).to have_received(:send_email) do |args|
          expect(args[:email_address]).to eq('cat@cathouse.com')
          expect(args[:personalisation]).to eq(access_url: 'http://cats.com' + '/?token=CatAccess')
        end
      end
    end
  end

  context 'example 2' do
    before do
      ENV['GOV_NOTIFY_API_KEY'] = 'megaSecure'
      ENV['GOV_NOTIFY_API_URL'] = 'dog.woof'
      described_class.new.send_notification(to: 'dog@doghouse.com', url: 'http://dogs.com', access_token: 'DogAccess')
    end

    context 'given email address and url' do
      it 'passes the API key and url to the notifications client' do
        expect(notifications_client_spy).to have_received(:new).with('megaSecure', 'dog.woof')
      end

      it 'will run send_email with address and url within personalisation hash' do
        expect(send_mail_spy).to have_received(:send_email) do |args|
          expect(args[:email_address]).to eq('dog@doghouse.com')
          expect(args[:personalisation]).to eq(access_url: 'http://dogs.com' + '/?token=DogAccess')
        end
      end
    end
  end
end
