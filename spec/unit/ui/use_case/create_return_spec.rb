# frozen_string_literal: true

describe UI::UseCase::CreateReturn do
  describe 'Example one' do
    let(:create_return_spy) { spy(execute: { id: 1 }) }
    let(:use_case) { described_class.new(create_return: create_return_spy) }
    let(:response) { use_case.execute(project_id: 3, data: { my_new_return: 'data' }) }

    before { response }

    it 'Calls the create return use case' do
      expect(create_return_spy).to have_received(:execute)
    end

    it 'Passes the project ID to create return use case' do
      expect(create_return_spy).to(
        have_received(:execute).with(hash_including(project_id: 3))
      )
    end

    it 'Passes the project data to create return use case' do
      expect(create_return_spy).to(
        have_received(:execute).with(
          hash_including(
            data: { my_new_return: 'data' }
          )
        )
      )
    end

    it 'Returns the created return id' do
      expect(response).to eq(id: 1)
    end
  end

  describe 'Example two' do
    let(:create_return_spy) { spy(execute: { id: 5 }) }
    let(:use_case) { described_class.new(create_return: create_return_spy) }
    let(:response) { use_case.execute(project_id: 8, data: { cats: 'say meow' }) }

    before { response }

    it 'Calls the create return use case' do
      expect(create_return_spy).to have_received(:execute)
    end

    it 'Passes the project ID to create return use case' do
      expect(create_return_spy).to(
        have_received(:execute).with(hash_including(project_id: 8))
      )
    end

    it 'Passes the project data to create return use case' do
      expect(create_return_spy).to(
        have_received(:execute).with(
          hash_including(
            data: { cats: 'say meow' }
          )
        )
      )
    end

    it 'Returns the created return id' do
      expect(response).to eq(id: 5)
    end
  end
end
