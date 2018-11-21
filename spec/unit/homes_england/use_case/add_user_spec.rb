describe HomesEngland::UseCase::AddUser do
  let(:user_gateway) { spy }
  let(:use_case) { described_class.new(user_gateway: user_gateway) }
  context 'calls the user gateway' do
    it 'example 1' do
      use_case.execute(email: 'cat@cathouse.com', role: 'Local Authority')
      expect(user_gateway).to have_received(:create) do |u|
        expect(u.email).to eq('cat@cathouse.com')
        expect(u.role).to eq('Local Authority')
      end
    end

    it 'example 2' do
      use_case.execute(email: 'dog@doghouse.com', role: 'Homes England')
      expect(user_gateway).to have_received(:create) do |u|
        expect(u.email).to eq('dog@doghouse.com')
        expect(u.role).to eq('Homes England')
      end
    end
  end

  context 'removes upper case from email address' do
    it 'example 1' do
      use_case.execute(email: 'THaTCaTHouSe@CaThouse.com', role: 'S151')
      expect(user_gateway).to have_received(:create) do |u|
        expect(u.email).to eq('thatcathouse@cathouse.com')
      end
    end

    it 'example 2' do
      use_case.execute(email: 'ThaTDoGHOUSE@DOGHOUSe.com', role: 'S151')
      expect(user_gateway).to have_received(:create) do |u|
        expect(u.email).to eq('thatdoghouse@doghouse.com')
      end
    end
  end
end
