describe HomesEngland::UseCase::AddUserToProject do
  let(:user_gateway) { spy(find_by: nil) }
  let(:use_case) { described_class.new(user_gateway: user_gateway) }

  context 'calls the gateway for a user with no permissions' do
    it 'example 1' do
      use_case.execute(email: 'cat@cathouse.com', project_id: 1)
      expect(user_gateway).to have_received(:create) do |user|
        expect(user.email).to eq('cat@cathouse.com')
        expect(user.projects).to eq([1])
      end
    end

    it 'example 2' do
      use_case.execute(email: 'dog@cathouse.com', project_id: 4)
      expect(user_gateway).to have_received(:create) do |user|
        expect(user.email).to eq('dog@cathouse.com')
        expect(user.projects).to eq([4])
      end
    end
  end

  context 'call the gateway for a user that already has data' do
    let(:new_user) do
      LocalAuthority::Domain::User.new.tap do |u|
        u.id = 1
        u.email = 'cat@cathouse.com'
        u.projects = [8]
      end
    end
    let(:user_gateway) do
      spy(
        find_by: new_user
      )
    end
    it 'example 1' do
      use_case.execute(email: 'cat@cathouse.com', project_id: 2)
      expect(user_gateway).to have_received(:update) do |user|
        expect(user.email).to eq('cat@cathouse.com')
        expect(user.projects).to eq([8, 2])
      end
    end

    it 'example 2' do
      use_case.execute(email: 'cat@cathouse.com', project_id: 3)
      expect(user_gateway).to have_received(:update) do |user|
        expect(user.email).to eq('cat@cathouse.com')
        expect(user.projects).to eq([8, 3])
      end
    end
  end
end
