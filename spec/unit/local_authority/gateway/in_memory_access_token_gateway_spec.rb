# frozen_string_literal: true

describe LocalAuthority::Gateway::InMemoryAccessTokenGateway do
  let(:gateway) { described_class.new }
  after do
    gateway.clear
  end

  before do
    gateway.clear
    gateway.create(access_token_one)
    gateway.create(access_token_two)
  end

  context 'with saved ids' do
    context 'example one' do
      let(:access_token_one) do
        LocalAuthority::Domain::AccessToken.new.tap do |token|
          token.uuid = 'cats'
        end
      end
      let(:access_token_two) do
        LocalAuthority::Domain::AccessToken.new.tap do |token|
          token.uuid = 'dogs'
        end
      end

      it 'can find saved access tokens' do
        expect(gateway.find_by(access_token: access_token_one)).to eq(0)
        expect(gateway.find_by(access_token: access_token_two)).to eq(1)
      end

      it 'can delete saved access tokens' do
        gateway.delete(access_token: access_token_one)
        expect(gateway.find_by(access_token: access_token_one)).to eq(nil)
      end
    end

    context 'example two' do
      let(:access_token_one) do
        LocalAuthority::Domain::AccessToken.new.tap do |token|
          token.uuid = 'cows'
        end
      end
      let(:access_token_two) do
        LocalAuthority::Domain::AccessToken.new.tap do |token|
          token.uuid = 'sheep'
        end
      end

      it 'can find saved access tokens' do
        expect(gateway.find_by(access_token: access_token_one)).to eq(0)
        expect(gateway.find_by(access_token: access_token_two)).to eq(1)
      end

      it 'can delete saved access tokens' do
        gateway.delete(access_token: access_token_one)
        expect(gateway.find_by(access_token: access_token_one)).to eq(nil)
      end
    end

    context 'after clear has run' do
      let(:access_token_one) do
        LocalAuthority::Domain::AccessToken.new.tap do |token|
          token.uuid = 'cows'
        end
      end
      let(:access_token_two) do
        LocalAuthority::Domain::AccessToken.new.tap do |token|
          token.uuid = 'sheep'
        end
      end
      
      before do
        gateway.clear
      end

      it 'can not find saved ids' do
        expect(gateway.find_by(access_token: access_token_one)).to eq(nil)
        expect(gateway.find_by(access_token: access_token_two)).to eq(nil)
      end
    end
  end
end
