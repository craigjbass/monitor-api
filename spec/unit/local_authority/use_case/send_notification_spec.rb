describe LocalAuthority::UseCase::SendNotification do

  let(:email_notification_gateway_spy) { spy }
  let(:use_case) {described_class.new(notification_gateway: email_notification_gateway_spy)}


  context 'example one' do
    it 'calls the email notification gateway' do
      use_case.execute(to: 'cats@cathouse.com', url: 'abc')
      expect(email_notification_gateway_spy).to have_received(:send_notification) do |args|
        expect(args[:to]).to eq('cats@cathouse.com')
        expect(args[:url]).to eq('abc')
      end
    end

  end

  context 'example two' do
    it 'calls the email notification gateway' do
      use_case.execute(to: 'dogs@doghouse.com', url: 'xyz')
      expect(email_notification_gateway_spy).to have_received(:send_notification) do |args|
        expect(args[:to]).to eq('dogs@doghouse.com')
        expect(args[:url]).to eq('xyz')
      end
    end
  end
end
