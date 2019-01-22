# frozen_string_literal: true

describe UI::UseCase::GetReturns do
  context 'Example one' do
    let(:convert_core_return_spy) { spy(execute: { rabbit: 'hops' }) }
    let(:find_project_spy) { spy(execute: { type: 'nil' }) }
    let(:get_returns_spy) do
      spy(execute: {
            returns:
            [{
              id: 1,
              project_id: 2,
              status: 'completed',
              updates: [{ bird: 'squarrrkk' }, { bird: 'squarrrkk' }]
            }]
          })
    end
    let(:use_case) do
      described_class.new(
        get_returns: get_returns_spy,
        find_project: find_project_spy,
        convert_core_return: convert_core_return_spy
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

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 2)
    end

    it 'Calls the convert core return use case with the data' do
      expect(convert_core_return_spy).to(
        have_received(:execute)
        .twice
        .with(return_data: { bird: 'squarrrkk' }, type: 'nil')
      )
    end

    it 'returns converted returns' do
      expect(response[:returns][0][:updates]).to eq([{ rabbit: 'hops' }, { rabbit: 'hops' }])
    end
  end

  context 'Example two' do
    let(:convert_core_return_spy) { spy(execute: { toad: 'ribbit' }) }
    let(:find_project_spy) { spy(execute: { type: 'non' }) }
    let(:get_returns_spy) do
      spy(execute: {
            returns: [{
              id: 3,
              project_id: 7,
              status: 'not done',
              updates: [{ dog: 'woof' }]
            }]
          })
    end
    let(:use_case) do
      described_class.new(
        get_returns: get_returns_spy,
        find_project: find_project_spy,
        convert_core_return: convert_core_return_spy
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

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 7)
    end

    it 'Calls the convert core return use case with the data' do
      expect(convert_core_return_spy).to(
        have_received(:execute)
        .once
        .with(return_data: { dog: 'woof' }, type: 'non')
      )
    end

    it 'returns converted returns' do
      expect(response[:returns]).to(eq(
                                      [
                                        {
                                          id: 3,
                                          project_id: 7,
                                          status: 'not done',
                                          updates: [{ toad: 'ribbit' }]
                                        }
                                      ]
                                    ))
    end
  end
end
