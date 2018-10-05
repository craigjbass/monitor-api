describe LocalAuthority::Gateway::SequelUsers do
  include_context 'with database'

  let(:gateway) { described_class.new(database: database) }

  context 'example one' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'example@example.com'
          u.projects = [1]
        end
      )
    end

    it 'returns an id for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by(email: 'example@example.com')
      expect(user.id).to eq(created_user_id)
    end

    it 'return nil when the email is not found' do
      new_user_id
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user).to eq(nil)
    end

    it 'grants permission for an email to access a given project' do
      new_user_id
      user = gateway.find_by(email: 'example@example.com')
      expect(user.projects).to eq([1])
    end

    it 'updates the user' do
      new_user_id
      user_to_update = gateway.find_by(email: 'example@example.com')
      user_to_update.projects = [2, 4, 8, 16]
      gateway.update(user_to_update)
      user = gateway.find_by(email: 'example@example.com')
      expect(user.projects).to eq([2, 4, 8, 16])
    end

    it 'gets multiple users' do
      user_one = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'example@example.com'
        u.projects = [1]
      end
      user_two = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'cat@cathouse.com'
        u.projects = [1]
      end
      gateway.create(
        user_one
      )
      gateway.create(
        user_two
      )

      users = gateway.get_users(project_id: 1)
      expect(users.length).to eq(2)
      expect(users[0].email).to eq('example@example.com')
      expect(users[1].email).to eq('cat@cathouse.com')
    end
  end

  context 'example two' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'cats@cathouse.com'
        end
      )
    end

    it 'returns an id for a given email' do
      created_user_id = new_user_id
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user.id).to eq(created_user_id)
    end

    it 'return nil when the email is not found' do
      new_user_id
      user = gateway.find_by(email: 'example@example.com')
      expect(user).to eq(nil)
    end

    it 'grants permission for an email to access a given project' do
      new_user_id
      user = gateway.find_by(email: 'cats@cathouse.com')
      expect(user.projects).to eq([])
    end

    it 'gets multiple users' do
      user_one = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'dogs@doghouse.com'
        u.projects = [6]
      end
      user_two = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'moo@cowhouse.com'
        u.projects = [6]
      end
      user_three = LocalAuthority::Domain::User.new.tap do |u|
        u.email = 'cow@cowhouse.com'
        u.projects = [7, 8]
      end
      user_one.id = gateway.create(
        user_one
      )
      user_two.id = gateway.create(
        user_two
      )
      user_three.id = gateway.create(
        user_three
      )

      users = gateway.get_users(project_id: 6)
      expect(users.length).to eq(2)
      expect(users[0].email).to eq('dogs@doghouse.com')
      expect(users[1].email).to eq('moo@cowhouse.com')
    end
  end

  context 'with mixed case emails' do
    let(:new_user_id) do
      gateway.create(
        LocalAuthority::Domain::User.new.tap do |u|
          u.email = 'CatsCatsCats@cathouse.com'
        end
      )
    end

    before { new_user_id }

    it 'Finds the email correctly' do
      found_user = gateway.find_by(email: 'CATSCATSCATS@cathouse.com')
      expect(found_user.id).to eq(new_user_id)
      expect(found_user.email).to eq('CatsCatsCats@cathouse.com')
    end
  end
end
