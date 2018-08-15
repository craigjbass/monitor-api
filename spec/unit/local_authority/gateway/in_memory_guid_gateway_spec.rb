# frozen_string_literal: true

describe LocalAuthority::Gateway::InMemoryGUIDGateway do
  let(:gateway) { described_class.new }
  after do
    gateway.clear
  end
  before do
    gateway.clear
    gateway.save(guid: guid_one)
    gateway.save(guid: guid_two)
  end
  context 'with saved ids' do
    context 'example one' do
      let(:guid_one) { 'cats' }
      let(:guid_two) { 'dogs' }

      it 'can find saved guids' do
        expect(gateway.find_by(guid: guid_one)).to eq(0)
        expect(gateway.find_by(guid: guid_two)).to eq(1)
      end

      it 'can delete saved guids' do
        gateway.delete(guid: guid_one)
        expect(gateway.find_by(guid: guid_one)).to eq(nil)
      end
    end

    context 'example two' do
      let(:guid_one) { 'cows' }
      let(:guid_two) { 'sheep' }

      it 'can find saved guids' do
        expect(gateway.find_by(guid: guid_one)).to eq(0)
        expect(gateway.find_by(guid: guid_two)).to eq(1)
      end

      it 'can delete saved guids' do
        gateway.delete(guid: guid_one)
        expect(gateway.find_by(guid: guid_one)).to eq(nil)
      end
    end

    context 'after clear has run' do
      let(:guid_one) { 'cows' }
      let(:guid_two) { 'sheep' }

      before do
        gateway.clear
      end

      it 'can not find saved ids' do
        expect(gateway.find_by(guid: guid_one)).to eq(nil)
        expect(gateway.find_by(guid: guid_two)).to eq(nil)
      end
    end
  end
end
