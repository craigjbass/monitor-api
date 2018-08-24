describe LocalAuthority::Gateway::SequelEmailWhitelistGateway, focus: true do
  let(:gateway) { described_class.new }

  context 'example one' do
    before do
      gateway.add('example@example.com')
    end

    it 'returns an id for a given email' do
      email_id = gateway.find_by('example@example.com')
      expect(email_id).to eq(0)
    end

    it 'return nil when the email is not found' do
      email_id = gateway.find_by('hello@world.com')
      expect(email_id).to eq(nil)
    end
  end

  context 'example two' do
    before do
      gateway.add('hello@world.com')
      gateway.add('cats@cathouse.com')
    end

    it 'returns an id for a given email' do
      email_id = gateway.find_by('cats@cathouse.com')
      expect(email_id).to eq(1)
    end

    it 'return nil when the email is not found' do
      email_id = gateway.find_by('dogs@doghouse.com')
      expect(email_id).to eq(nil)
    end
  end
end
