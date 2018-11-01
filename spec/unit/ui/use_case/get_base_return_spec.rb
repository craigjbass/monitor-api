# frozen_string_literal: true

describe UI::UseCase::GetBaseReturn do
  context 'Example one' do
    let(:get_base_return_spy) { spy(execute: { base_return: { cat: 'meow' } }) }
    let(:use_case) { described_class.new(get_base_return: get_base_return_spy) }
    let(:response) { use_case.execute(project_id: 4) }

    before { response }

    it 'Calls execute on the get base return usecase' do
      expect(get_base_return_spy).to have_received(:execute)
    end

    it 'Passes the project ID to get base return' do
      expect(get_base_return_spy).to have_received(:execute).with(project_id: 4)
    end

    it 'Returns the basereturn from get base return' do
      expect(response).to eq(base_return: { cat: 'meow' })
    end
  end

  context 'Example two' do
    let(:get_base_return_spy) { spy(execute: { base_return: { dog: 'woof' } }) }
    let(:use_case) { described_class.new(get_base_return: get_base_return_spy) }
    let(:response) { use_case.execute(project_id: 7) }

    before { response }

    it 'Calls execute on the get base return usecase' do
      expect(get_base_return_spy).to have_received(:execute)
    end

    it 'Passes the project ID to get base return' do
      expect(get_base_return_spy).to have_received(:execute).with(project_id: 7)
    end

    it 'Returns the basereturn from get base return' do
      expect(response).to eq(base_return: { dog: 'woof' })
    end
  end
end
