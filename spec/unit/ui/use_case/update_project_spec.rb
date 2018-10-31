# frozen_string_literal: true

describe UI::UseCase::UpdateProject do
  context 'Example one' do
    let(:update_project_spy) { spy(execute: { successful: true }) }
    let(:use_case) { described_class.new(update_project: update_project_spy) }
    let(:response) { use_case.execute(id: 7, data: { cat: 'meow' }) }

    before { response }

    it 'Calls execute on the update project usecase' do
      expect(update_project_spy).to have_received(:execute)
    end

    it 'Passes the update project use case the project ID' do
      expect(update_project_spy).to(
        have_received(:execute).with(hash_including(project_id: 7))
      )
    end

    it 'Passes the update project use case the project data' do
      expect(update_project_spy).to(
        have_received(:execute).with(
          hash_including(
            project_data: { cat: 'meow' }
          )
        )
      )
    end

    it 'Returns successful if successful' do
      expect(response).to eq(successful: true)
    end
  end

  context 'Example two' do
    let(:update_project_spy) { spy(execute: { successful: false }) }
    let(:use_case) { described_class.new(update_project: update_project_spy) }
    let(:response) { use_case.execute(id: 2, data: { dog: 'woof' }) }

    before { response }

    it 'Calls execute on the update project usecase' do
      expect(update_project_spy).to have_received(:execute)
    end

    it 'Passes the update project use case the project ID' do
      expect(update_project_spy).to(
        have_received(:execute).with(hash_including(project_id: 2))
      )
    end

    it 'Passes the update project use case the project data' do
      expect(update_project_spy).to(
        have_received(:execute).with(
          hash_including(
            project_data: { dog: 'woof' }
          )
        )
      )
    end

    it 'Returns successful if successful' do
      expect(response).to eq(successful: false)
    end
  end
end
