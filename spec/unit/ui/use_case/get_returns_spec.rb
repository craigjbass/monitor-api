# frozen_string_literal: true

describe UI::UseCase::GetReturns do
  context 'Example one' do
    let(:get_returns_spy) { spy(execute: { returns: [{ cat: 'meow' }] }) }
    let(:use_case) { described_class.new(get_returns: get_returns_spy) }
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
  end

  context 'Example two' do
    let(:get_returns_spy) { spy(execute: { returns: [{ dog: 'woof' }] }) }
    let(:use_case) { described_class.new(get_returns: get_returns_spy) }
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
  end
end
