# frozen_string_literal: true

describe LocalAuthority::UseCase::UpdateReturn do
  let(:return_gateway) { spy }

  context 'example one' do
    let(:update_return) do
      described_class.new(return_gateway: return_gateway).execute(
        return_id: 12, data: { cats: 'meow' }
      )
    end

    it 'sends the correct id to the return gateway' do
      expect(update_return).to have_received(:update).with(hash_including(return_id: 12))
    end
    it 'sends the project data to the return gateway' do
      expect(update_return).to have_received(:update).with(hash_including(
                                                             data: {
                                                               cats: 'meow'
                                                             }
                                                           ))
    end
  end

  context 'example two' do
    let(:update_return) do
      described_class.new(return_gateway: return_gateway).execute(
        return_id: 42, data: { dogs: 'woof' }
      )
    end

    it 'sends the correct id to the return gateway' do
      expect(update_return).to have_received(:update).with(hash_including(return_id: 42))
    end
    it 'sends the project data to the return gateway' do
      expect(update_return).to have_received(:update).with(hash_including(
                                                             data: {
                                                               dogs: 'woof'
                                                             }
                                                           ))
    end
  end
end
