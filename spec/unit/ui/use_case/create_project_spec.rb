# frozen_string_literal: true

describe UI::UseCase::CreateProject do
  context 'Example one' do
    let(:create_project_spy) { spy(execute: { id: 1 }) }
    let(:use_case) { described_class.new(create_project: create_project_spy) }
    let(:response) do
      use_case.execute(type: 'hif', name: 'Cats', baseline: { Cats: 'purr' }) 
    end

    before do
      response
    end

    it 'Calls execute on the create project usecase' do
      expect(create_project_spy).to have_received(:execute)
    end

    it 'Calls execute on the create project usecase with the project type' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(type: 'hif'))
      )
    end

    it 'Calls execute on the create project usecase with the project name' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(name: 'Cats'))
      )
    end

    it 'Calls execute on the create project usecase with the baseline' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(baseline: { Cats: 'purr' }))
      )
    end

    it 'Returns the id from create project' do
      expect(response).to eq(id: 1)
    end
  end

  context 'Example one' do
    let(:create_project_spy) { spy(execute: { id: 5 }) }
    let(:use_case) { described_class.new(create_project: create_project_spy) }
    let(:response) do
      use_case.execute(type: 'laac', name: 'Dogs', baseline: { doggos: 'woof' })
    end

    before do
      response
    end

    it 'Calls execute on the create project usecase' do
      expect(create_project_spy).to have_received(:execute)
    end

    it 'Calls execute on the create project usecase with the project type' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(type: 'laac'))
      )
    end

    it 'Calls execute on the create project usecase with the project name' do
      expect(create_project_spy).to(
        have_received(:execute).with(hash_including(name: 'Dogs'))
      )
    end

    it 'Calls execute on the create project usecase with the baseline' do
      expect(create_project_spy).to(
        have_received(:execute).with(
          hash_including(
            baseline: { doggos: 'woof' }
          )
        )
      )
    end

    it 'Returns the id from create project' do
      expect(response).to eq(id: 5)
    end
  end
end
