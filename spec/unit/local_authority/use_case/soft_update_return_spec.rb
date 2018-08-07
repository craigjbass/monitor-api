# frozen_string_literal: true

describe LocalAuthority::UseCase::SoftUpdateReturn do
  let(:return_gateway) { spy }
  #{update_id, return_id, data}

  before do
    soft_update_return
  end

  context 'example 1' do
    let(:soft_update_return) do
      described_class.new(return_gateway: return_gateway).execute(
        return_id: 12, return_data: { cats: 'meow' }
      )
    end

    it 'requests a soft update from return_gateway (example 1)' do
      expect(return_gateway).to have_received(:soft_update).with(return_id: 12, return_data: { cats: 'meow' })
    end
  end

  context 'example 2' do
    let(:soft_update_return) do
      described_class.new(return_gateway: return_gateway).execute(
        return_id: 7, return_data: { dogs: 'woof' }
      )
    end

    it 'requests a soft update from return_gateway (example 2)' do
      expect(return_gateway).to have_received(:soft_update).with(return_id: 7, return_data: { dogs: 'woof' })
    end
  end
end
