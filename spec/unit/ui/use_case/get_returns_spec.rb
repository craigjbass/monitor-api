# frozen_string_literal: true

describe UI::UseCase::GetReturns do
  context 'Example one' do
    let(:convert_core_return_spy) { spy }
    let(:find_project_spy) { spy(execute: {type:'nil'})}
    let(:get_returns_spy) { spy(execute: { returns: [{ cat: 'meow' }] }) }
    let(:use_case) do 
      described_class.new(
        get_returns: get_returns_spy,
        find_project: find_project_spy,
        convert_core_hif_return: convert_core_return_spy
        )
    end 
    let(:response) { use_case.execute(project_id: 2) }

    before { response }

    it 'Calls execute on the get returns usecase' do
      expect(get_returns_spy).to have_received(:execute)
    end

    it 'Passes the project ID to the get returns use case' do
      expect(get_returns_spy).to have_received(:execute).with(project_id: 2)
    end

    it 'Returns the found returns' do
      expect(response).to eq(returns: [{ cat: 'meow' }])
    end

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    context 'Hif type' do
      let(:get_returns_spy) do
        spy(
          execute: {
            returns: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
          }
        )
      end
      let(:find_project_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_core_return_spy) { spy(execute: { rabbit: 'hops' }) }

      it 'Calls the convert core return use case with the data' do
        expect(convert_core_return_spy).to(
          have_received(:execute)
          .twice
          .with(return_data: { bird: 'squarrrkk' })
        )
      end

      it 'returns converted returns' do
        expect(response[:returns]).to eq([{ rabbit: 'hops' }, { rabbit: 'hops' }])
      end
    end

    context 'NON HIF type' do
      it 'doesnt call the convert core use case' do
        expect(convert_core_return_spy).not_to have_received(:execute)
      end
    end
  end

  context 'Example two' do
    let(:convert_core_return_spy) { spy }
    let(:find_project_spy) { spy(execute: { type: 'non' })}
    let(:get_returns_spy) { spy(execute: { returns: [{ dog: 'woof' }] }) }
    let(:use_case) do 
      described_class.new(
        get_returns: get_returns_spy,
        find_project: find_project_spy,
        convert_core_hif_return: convert_core_return_spy
        )
    end
    let(:response) { use_case.execute(project_id: 7) }

    before { response }

    it 'Calls execute on the get returns usecase' do
      expect(get_returns_spy).to have_received(:execute)
    end

    it 'Passes the project ID to the get returns use case' do
      expect(get_returns_spy).to have_received(:execute).with(project_id: 7)
    end

    it 'Returns the found returns' do
      expect(response).to eq(returns: [{ dog: 'woof' }])
    end

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 7)
    end

    context 'Hif type' do
      let(:get_returns_spy) do
        spy(execute: {
              returns: [{ pony: 'nah' }, { pony: 'nah' }]
            })
      end
      let(:find_project_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_core_return_spy) { spy(execute: { toad: 'ribbit' }) }

      it 'Calls the convert core return use case with the data' do
        expect(convert_core_return_spy).to(
          have_received(:execute)
          .twice
          .with(return_data: { pony: 'nah' })
        )
      end

      it 'returns converted returns' do
        expect(response[:returns]).to eq([{ toad: 'ribbit' }, { toad: 'ribbit' }])
      end
    end

    context 'NON HIF type' do
      it 'doesnt call the convert core use case' do
        expect(convert_core_return_spy).not_to have_received(:execute)
      end
    end
  end
end
