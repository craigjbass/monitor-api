# frozen_string_literal: true

describe UI::UseCase::UpdateReturn do
  context 'Example one' do
    let(:get_return_spy) { spy(execute: { type: 'nein' }) }
    let(:convert_ui_return_spy) { spy(execute: { stork: 'gives babies' }) }
    let(:update_return_spy) { spy }
    let(:use_case) do
      described_class.new(
        update_return: update_return_spy,
        convert_ui_return: convert_ui_return_spy,
        get_return: get_return_spy
      )
    end
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

    it 'returns an empty hash' do
      expect(response).to eq({})
    end

    it 'call the get return use case' do
      expect(get_return_spy).to have_received(:execute).with(id: 1)
    end

    it 'call the convert ui return use case with return' do
      expect(convert_ui_return_spy).to have_received(:execute).with(
        return_data: { cat: 'meow' }, type: 'nein'
        )
    end

    it 'Calls execute on update return with the converted return data' do
      expect(update_return_spy).to(
        have_received(:execute).with(
          hash_including(return_data: { stork: 'gives babies' })
        )
      )
    end
  end

  context 'Example two' do
    let(:get_return_spy) { spy(execute: { type: 'non' }) }
    let(:convert_ui_return_spy) { spy(execute: { puppies: 'play' }) }
    let(:update_return_spy) { spy }
    let(:use_case) do
      described_class.new(
        update_return: update_return_spy,
        convert_ui_return: convert_ui_return_spy,
        get_return: get_return_spy
      )
    end
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

    it 'returns an empty hash' do
      expect(response).to eq({})
    end

    it 'call the get return use case' do
      expect(get_return_spy).to have_received(:execute).with(id: 6)
    end

    it 'call the convert ui return use case with return' do
      expect(convert_ui_return_spy).to have_received(:execute).with(
        return_data: {dog: 'woof'}, type: 'non'
        )
    end

    it 'Calls execute on update return with the converted return data' do
      expect(update_return_spy).to(
        have_received(:execute).with(
          hash_including(return_data: { puppies: 'play' })
        )
      )
    end
  end
end
