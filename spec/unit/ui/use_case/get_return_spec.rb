# frozen_string_literal: true

describe UI::UseCase::GetReturn do
  describe 'Example one' do
    let(:convert_core_return_spy) { spy }
    let(:get_return_spy) do
      spy(
        execute: {
          id: 1,
          type: 'cat',
          project_id: 2,
          status: 'Meow',
          updates: [{ dog: 'woof' }]
        }
      )
    end
    let(:use_case) { described_class.new(get_return: get_return_spy, convert_core_hif_return: convert_core_return_spy) }
    let(:response) { use_case.execute(id: 1) }

    before { response }

    it 'Calls the get return use case' do
      expect(get_return_spy).to have_received(:execute)
    end

    it 'Passes the ID to the get return usecase' do
      expect(get_return_spy).to have_received(:execute).with(id: 1)
    end

    it 'Returns the ID from the get return use case' do
      expect(response[:id]).to eq(1)
    end

    it 'Returns the type from the get return use case' do
      expect(response[:type]).to eq('cat')
    end

    it 'Returns the project id from the get return use case' do
      expect(response[:project_id]).to eq(2)
    end

    it 'Returns the status from the get return use case' do
      expect(response[:status]).to eq('Meow')
    end

    it 'Returns the updates from the get return use case' do
      expect(response[:updates]).to eq([{ dog: 'woof' }])
    end

    context 'Hif type' do
      let(:get_return_spy) do
        spy(
          execute: {
            id: 1,
            type: 'hif',
            project_id: 2,
            status: 'Meow',
            updates: [{ dog: 'woof' }, { dog: 'woof' }]
          }
        )
      end
      let(:find_project_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_core_return_spy) { spy(execute: { fly: 'buz' }) }

      it 'Calls the convert core return use case with the data' do
        expect(convert_core_return_spy).to(
          have_received(:execute)
          .twice
          .with(return_data: { dog: 'woof' })
        )
      end

      it 'returns converted returns' do
        expect(response[:updates]).to eq([{ fly: 'buz' }, { fly: 'buz' }])
      end
    end

    context 'NON HIF type' do
      it 'doesnt call the convert core use case' do
        expect(convert_core_return_spy).not_to have_received(:execute)
      end
    end
  end

  describe 'Example two' do
    let(:convert_core_return_spy) { spy }
    let(:get_return_spy) do
      spy(
        execute: {
          id: 5,
          type: 'dog',
          project_id: 7,
          status: 'Woof',
          updates: [{ duck: 'quack' }]
        }
      )
    end
    let(:use_case) { described_class.new(get_return: get_return_spy, convert_core_hif_return: convert_core_return_spy) }
    let(:response) { use_case.execute(id: 5) }

    before { response }

    it 'Calls the get return use case' do
      expect(get_return_spy).to have_received(:execute)
    end

    it 'Passes the ID to the get return usecase' do
      expect(get_return_spy).to have_received(:execute).with(id: 5)
    end

    it 'Returns the ID from the get return use case' do
      expect(response[:id]).to eq(5)
    end

    it 'Returns the type from the get return use case' do
      expect(response[:type]).to eq('dog')
    end

    it 'Returns the project id from the get return use case' do
      expect(response[:project_id]).to eq(7)
    end

    it 'Returns the status from the get return use case' do
      expect(response[:status]).to eq('Woof')
    end

    it 'Returns the updates from the get return use case' do
      expect(response[:updates]).to eq([{ duck: 'quack' }])
    end

    context 'Hif type' do
      let(:get_return_spy) do
        spy(
          execute: {
            id: 5,
            type: 'hif',
            project_id: 7,
            status: 'Woof',
            updates: [{ duck: 'quack' }, { duck: 'quack' }]
          }
        )
      end
      let(:find_project_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_core_return_spy) { spy(execute: { goat: 'meh' }) }

      it 'Calls the convert core return use case with the data' do
        expect(convert_core_return_spy).to(
          have_received(:execute)
          .twice
          .with(return_data: { duck: 'quack' })
        )
      end

      it 'returns converted returns' do
        expect(response[:updates]).to eq([{ goat: 'meh' }, { goat: 'meh' }])
      end
    end

    context 'NON HIF type' do
      it 'doesnt call the convert core use case' do
        expect(convert_core_return_spy).not_to have_received(:execute)
      end
    end
  end
end
