# frozen_string_literal: true

describe LocalAuthority::Gateway::InMemoryAPIKeyGateway do
  let(:gateway) { described_class.new }
  after do
    gateway.clear
  end
  before do
    gateway.clear
    gateway.save(api_key: api_key_one)
    gateway.save(api_key: api_key_two)
  end
  context 'with saved api keys' do
    context 'example one' do
      let(:api_key_one) { 'cats' }
      let(:api_key_two) { 'dogs' }

      it 'can find saved api keys' do
        expect(gateway.find_by(api_key: api_key_one)).to eq(0)
        expect(gateway.find_by(api_key: api_key_two)).to eq(1)
      end

      it 'can delete saved api keys' do
        gateway.delete(api_key: api_key_one)
        expect(gateway.find_by(api_key: api_key_one)).to eq(nil)
      end
    end

    context 'example two' do
      let(:api_key_one) { 'cows' }
      let(:api_key_two) { 'sheep' }

      it 'can find saved api keys' do
        expect(gateway.find_by(api_key: api_key_one)).to eq(0)
        expect(gateway.find_by(api_key: api_key_two)).to eq(1)
      end

      it 'can delete saved api keys' do
        gateway.delete(api_key: api_key_one)
        expect(gateway.find_by(api_key: api_key_one)).to eq(nil)
      end
    end

    context 'after clear has run' do
      let(:api_key_one) { 'cows' }
      let(:api_key_two) { 'sheep' }

      before do
        gateway.clear
      end

      it 'can not find api keys' do
        expect(gateway.find_by(api_key: api_key_one)).to eq(nil)
        expect(gateway.find_by(api_key: api_key_two)).to eq(nil)
      end
    end
  end
end
