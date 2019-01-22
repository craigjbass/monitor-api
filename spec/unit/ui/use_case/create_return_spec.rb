# frozen_string_literal: true

describe UI::UseCase::CreateReturn do
  describe 'Example one' do
    let(:find_project_spy) { spy(execute: { type: 'hif' }) }
    let(:create_return_spy) { spy(execute: { id: 1 }) }
    let(:convert_ui_return_spy) { spy(execute: { Cows: 'moo' }) }
    let(:use_case) { described_class.new(create_return: create_return_spy, convert_ui_return: convert_ui_return_spy, find_project: find_project_spy) }
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
            data: { Cows: 'moo' }
          )
        )
      )
    end

    it 'Returns the created return id' do
      expect(response).to eq(id: 1)
    end

    it 'Calls the find project use case with the ID' do 
      expect(find_project_spy).to have_received(:execute).with(id: 3)
    end

    it 'Calls execute on the convert use case' do
      expect(convert_ui_return_spy).to have_received(:execute)
    end

    it 'Passes the project data to the converter' do
      expect(convert_ui_return_spy).to have_received(:execute).with(
        return_data: { my_new_return: 'data' }, type: 'hif'
      )
    end

    it 'Creates the project with the converted data' do
      expect(create_return_spy).to(
        have_received(:execute).with(hash_including(data: { Cows: 'moo' }))
      )
    end
  end

  describe 'Example two' do
    let(:find_project_spy) { spy(execute: { type: 'nothif' }) }
    let(:convert_ui_return_spy) { spy( execute: { ponnies: 'nay'})}
    let(:create_return_spy) { spy(execute: { id: 5 }) }
    let(:use_case) do
      described_class.new(
        create_return: create_return_spy,
        convert_ui_return:
        convert_ui_return_spy,
        find_project: find_project_spy
      )
    end
    let(:response) { use_case.execute(project_id: 8, data: { Dogs: 'moo' })}

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
            data: { ponnies: 'nay' }
          )
        )
      )
    end

    it 'Returns the created return id' do
      expect(response).to eq(id: 5)
    end

    it 'Calls the find project use case with the ID' do 
      expect(find_project_spy).to have_received(:execute).with(id: 8)
    end

    it 'Calls execute on the convert use case' do
      expect(convert_ui_return_spy).to have_received(:execute)
    end

    it 'Passes the return data to the converter' do
      expect(convert_ui_return_spy).to have_received(:execute).with(
        return_data: { Dogs: 'moo' }, type: 'nothif'
      )
    end

    it 'Creates the return with the converted data' do
      expect(create_return_spy).to(
        have_received(:execute).with(hash_including(data: { ponnies: 'nay'}))
      )
    end
  end
end
