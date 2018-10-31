# frozen_string_literal: true

describe UI::UseCase::GetProject do
  describe 'Example 1' do
    let(:find_project_spy) do
      spy(
        execute: {
          name: 'Big Buildings',
          type: 'hif',
          data: { building1: 'a house' },
          status: 'Draft'
        }
      )
    end
    let(:use_case) { described_class.new(find_project: find_project_spy) }
    let(:response) { use_case.execute(id: 1) }

    before do
      response
    end

    it 'Calls execute in the find project use case' do
      expect(find_project_spy).to have_received(:execute)
    end

    it 'Passes the ID to the find project usecase' do
      expect(find_project_spy).to have_received(:execute).with(id: 1)
    end

    it 'Return the name from find project' do
      expect(response[:name]).to eq('Big Buildings')
    end

    it 'Return the type from find project' do
      expect(response[:type]).to eq('hif')
    end

    it 'Return the type from find project' do
      expect(response[:data]).to eq(building1: 'a house')
    end

    it 'Return the status from find project' do
      expect(response[:status]).to eq('Draft')
    end
  end

  describe 'Example 2' do
    let(:find_project_spy) do
      spy(
        execute: {
          name: 'Big ol woof',
          type: 'dogs',
          data: { noise: 'bark' },
          status: 'Barking'
        }
      )
    end
    let(:use_case) { described_class.new(find_project: find_project_spy) }
    let(:response) { use_case.execute(id: 5) }

    before do
      response
    end

    it 'Calls execute in the find project use case' do
      expect(find_project_spy).to have_received(:execute)
    end

    it 'Passes the ID to the find project usecase' do
      expect(find_project_spy).to have_received(:execute).with(id: 5)
    end

    it 'Return the name from find project' do
      expect(response[:name]).to eq('Big ol woof')
    end

    it 'Return the type from find project' do
      expect(response[:type]).to eq('dogs')
    end

    it 'Return the type from find project' do
      expect(response[:data]).to eq(noise: 'bark')
    end

    it 'Return the status from find project' do
      expect(response[:status]).to eq('Barking')
    end
  end
end
