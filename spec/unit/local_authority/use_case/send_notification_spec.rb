describe LocalAuthority::UseCase::SendNotification do

  let(:email_notification_gateway_spy) { spy }
  let(:use_case) {described_class.new(notification_gateway: email_notification_gateway_spy)}


  context 'example one' do
    it 'calls the email notification gateway' do
      use_case.execute(to: 'cats@cathouse.com', url: 'abc', access_token:'cats')
      expect(email_notification_gateway_spy).to have_received(:send_notification) do |args|
        expect(args[:to]).to eq('cats@cathouse.com')
        expect(args[:url]).to eq('abc')
        expect(args[:access_token]).to eq('cats')
      end
    end

    it 'cleans a dirty url' do
      use_case.execute(to: 'cats@cathouse.com', url: 'http://hif.homesengland.org.uk/projects/15/?token=15753', access_token:'cats')
      expect(email_notification_gateway_spy).to have_received(:send_notification) do |args|
        expect(args[:to]).to eq('cats@cathouse.com')
        expect(args[:url]).to eq('http://hif.homesengland.org.uk/projects/15')
        expect(args[:access_token]).to eq('cats')
      end
    end

  end

  context 'example two' do
    it 'calls the email notification gateway' do
      use_case.execute(to: 'dogs@doghouse.com', url: 'xyz', access_token:'dogs')
      expect(email_notification_gateway_spy).to have_received(:send_notification) do |args|
        expect(args[:to]).to eq('dogs@doghouse.com')
        expect(args[:url]).to eq('xyz')
        expect(args[:access_token]).to eq('dogs')
      end
    end

    it 'cleans a dirty url' do
      use_case.execute(to: 'cats@cathouse.com', url: 'http://hif.homesengland.org.uk/projects/15?token=15753&ref=gmail', access_token:'cats')
      expect(email_notification_gateway_spy).to have_received(:send_notification) do |args|
        expect(args[:to]).to eq('cats@cathouse.com')
        expect(args[:url]).to eq('http://hif.homesengland.org.uk/projects/15')
        expect(args[:access_token]).to eq('cats')
      end
    end
  end
end
