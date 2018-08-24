describe LocalAuthority::Gateway::SequelEmailWhitelistGateway, focus: true do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context 'example one' do
    let(:new_user_id) { gateway.create('example@example.com', [1]) }

    it 'returns an id for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by('example@example.com')
      expect(user.id).to eq(created_user_id)
    end

    it 'return nil when the email is not found' do
      new_user_id
      user = gateway.find_by('cats@cathouse.com')
      expect(user).to eq(nil)
    end

    it 'grants permission for an email to access a given project' do
      new_user_id
      user = gateway.find_by('example@example.com')
      expect(user.projects).to eq([1])
    end
  end

  context 'example two' do
    let(:new_user_id) { gateway.create('cats@cathouse.com') }

    it 'returns an id for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by('cats@cathouse.com')
      expect(user.id).to eq(created_user_id)
    end

    it 'return nil when the email is not found' do
      new_user_id
      user = gateway.find_by('example@example.com')
      expect(user).to eq(nil)
    end

    it 'grants permission for an email to access a given project' do
      new_user_id
      user = gateway.find_by('cats@cathouse.com')
      expect(user.projects).to eq([])
    end
  end
end
