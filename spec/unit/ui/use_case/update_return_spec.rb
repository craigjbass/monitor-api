# frozen_string_literal: true

describe UI::UseCase::UpdateReturn do
  context 'Example one' do
    let(:update_return_spy) { spy }
    let(:use_case) { described_class.new(update_return: update_return_spy) }
    let(:response) do
      use_case.execute(return_id: 1, return_data: { cat: 'meow' })
    end

    before { response }

    it 'Calls execute on update return' do
      expect(update_return_spy).to have_received(:execute)
    end

    it 'Calls execute on update return with the return ID' do
      expect(update_return_spy).to(
        have_received(:execute).with(hash_including(return_id: 1))
      )
    end

    it 'Calls execute on update return with the return data' do
      expect(update_return_spy).to(
        have_received(:execute).with(
          hash_including(return_data: { cat: 'meow' })
        )
      )
    end

    it 'returns an empty hash' do
      expect(response).to eq({})
    end
  end

  context 'Example one' do
    let(:update_return_spy) { spy }
    let(:use_case) { described_class.new(update_return: update_return_spy) }
    let(:response) do
      use_case.execute(return_id: 6, return_data: { dog: 'woof' })
    end

    before { response }

    it 'Calls execute on update return' do
      expect(update_return_spy).to have_received(:execute)
    end

    it 'Calls execute on update return with the return ID' do
      expect(update_return_spy).to(
        have_received(:execute).with(hash_including(return_id: 6))
      )
    end

    it 'Calls execute on update return with the return data' do
      expect(update_return_spy).to(
        have_received(:execute).with(
          hash_including(return_data: { dog: 'woof' })
        )
      )
    end

    it 'returns an empty hash' do
      expect(response).to eq({})
    end
  end
end
