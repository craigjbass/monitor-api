# frozen_string_literal: true

describe LocalAuthority::UseCase::SoftUpdateReturn do
  let(:return_update_gateway) { spy }
  #{update_id, return_id, data}

  before do
    soft_update_return
  end

  context 'example 1' do
    let(:soft_update_return) do
      described_class.new(return_update_gateway: return_update_gateway).execute(
        return_id: 12, return_data: { cats: 'meow' }
      )
    end

    it 'requests a soft update from return_gateway' do
      expect(return_update_gateway).to have_received(:create) do |return_update|
        expect(return_update.return_id).to eq(12)
      end
    end

    it 'requests a soft update from return_gateway with the correct data' do
      expect(return_update_gateway).to have_received(:create) do |return_update|
        expect(return_update.data).to eq({cats: 'meow'})
      end
    end
  end

  context 'example 2' do
    let(:soft_update_return) do
      described_class.new(return_update_gateway: return_update_gateway).execute(
        return_id: 7, return_data: { dogs: 'woof' }
      )
    end

    it 'requests a soft update from return_gateway' do
      expect(return_update_gateway).to have_received(:create) do |return_update|
        expect(return_update.return_id).to eq(7)
      end
    end

    it 'requests a soft update from return_gateway with the correct data' do
      expect(return_update_gateway).to have_received(:create) do |return_update|
        expect(return_update.data).to eq({dogs: 'woof'})
      end
    end
  end
end
