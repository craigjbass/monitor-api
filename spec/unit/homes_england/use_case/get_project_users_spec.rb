describe HomesEngland::UseCase::GetProjectUsers do
  let(:users) { [] }
  let(:user_gateway_spy) { spy(get_users: users) }
  let(:use_case) { described_class.new(user_gateway: user_gateway_spy) }
  context 'calls the users gateway' do
    example 'example 1' do
      use_case.execute(project_id: 2)
      expect(user_gateway_spy).to have_received(:get_users).with(project_id: 2)
    end

    example 'example 2' do
      use_case.execute(project_id: 255)
      expect(user_gateway_spy).to have_received(:get_users).with(project_id: 255)
    end
  end

  context 'returns an array of users' do
    context 'example 1' do
      let(:users) do
        [
          LocalAuthority::Domain::User.new.tap do |u|
            u.id = 1
            u.email = 'cat@cathouse.com'
            u.projects = []
            u.projects = [255]
          end
        ]
      end

      it 'returns an array of matching users' do
        expect(use_case.execute(project_id: 255)).to eq(users: ['cat@cathouse.com'])
      end
    end

    context 'example 2' do
      let(:users) do
        [
          LocalAuthority::Domain::User.new.tap do |u|
            u.id = 22
            u.email = 'dog@doghouse.com'
            u.projects = []
            u.projects = [1415]
          end,
          LocalAuthority::Domain::User.new.tap do |u|
            u.id = 80
            u.email = 'moo@cowhouse.com'
            u.projects = []
            u.projects = [1415]
          end,
        ]
      end

      it 'returns an array of matching users' do
        expect(use_case.execute(project_id: 1415)).to eq(users: ['dog@doghouse.com', 'moo@cowhouse.com'])
      end
    end
  end
end
