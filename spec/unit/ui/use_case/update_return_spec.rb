# frozen_string_literal: true

describe UI::UseCase::UpdateReturn do
  context 'Example one' do
    let(:get_return_spy) { spy(execute: { type: 'nein' }) }
    let(:convert_ui_hif_return_spy) { spy }
    let(:update_return_spy) { spy }
    let(:use_case) do
      described_class.new(
        update_return: update_return_spy,
        convert_ui_hif_return: convert_ui_hif_return_spy,
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

    it 'call the get return use case' do
      expect(get_return_spy).to have_received(:execute).with(id: 1)
    end

    context 'A non hif project' do
      it 'doesnt call the convert ui return use case' do
        expect(convert_ui_hif_return_spy).not_to have_received(:execute)
      end
    end

    context 'A hif project' do
      let(:get_return_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_ui_hif_return_spy) { spy(execute: { stork: 'gives babies' }) }

      it 'call the convert ui return use case with return' do
        expect(convert_ui_hif_return_spy).to have_received(:execute).with(return_data: { cat: 'meow' })
      end

      it 'pass the converted data to the update project use case' do
        expect(update_return_spy).to(
          have_received(:execute).with(
            hash_including(return_data: { stork: 'gives babies' })
          )
        )
      end
    end
  end

  context 'Example two' do
    let(:get_return_spy) { spy(execute: { type: 'non' }) }
    let(:convert_ui_hif_return_spy) { spy }
    let(:update_return_spy) { spy }
    let(:use_case) do
      described_class.new(
        update_return: update_return_spy,
        convert_ui_hif_return: convert_ui_hif_return_spy,
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

    it 'call the get return use case' do
      expect(get_return_spy).to have_received(:execute).with(id: 6)
    end

    context 'A non hif project' do
      it 'doesnt call the convert ui return use case' do
        expect(convert_ui_hif_return_spy).not_to have_received(:execute)
      end
    end

    context 'A hif project' do
      let(:get_return_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_ui_hif_return_spy) { spy(execute: { puppies: 'play' }) }

      it 'call the convert ui return use case with return' do
        expect(convert_ui_hif_return_spy).to have_received(:execute).with(return_data: {dog: 'woof'})
      end

      it 'pass the converted data to the update project use case' do
        expect(update_return_spy).to(
          have_received(:execute).with(
            hash_including(return_data: { puppies: 'play' })
          )
        )
      end
    end
  end
end
