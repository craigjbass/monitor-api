# frozen_string_literal: true

describe HomesEngland::UseCase::DeleteUser do
  let(:user_gateway) { spy }
  let(:use_case) { described_class.new(user_gateway: user_gateway) }

  context 'calls the user gateway' do
    it 'example 1' do
      use_case.execute(email: 'cat@cathouse.com')
      expect(user_gateway).to have_received(:delete_user).with('cat@cathouse.com')
    end

    it 'example 2' do
      use_case.execute(email: 'dogs@dogkennel.co.uk')
      expect(user_gateway).to have_received(:delete_user).with('dogs@dogkennel.co.uk')
    end
  end

  context 'removes upper case from email address' do
    it 'example 1' do
      use_case.execute(email: 'THaTCaTHouSe@CaThouse.com')
      expect(user_gateway).to have_received(:delete_user).with('thatcathouse@cathouse.com')
    end

    it 'example 2' do
      use_case.execute(email: 'ThaTDoGHOUSE@DOGHOUSe.com')
      expect(user_gateway).to have_received(:delete_user).with('thatdoghouse@doghouse.com')
    end
  end
end
