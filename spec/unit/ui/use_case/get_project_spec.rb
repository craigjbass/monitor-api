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
    let(:convert_core_hif_project_spy) { spy(execute: { building2: 'a house' }) }
    let(:use_case) do
      described_class.new(
        find_project: find_project_spy,
        convert_core_hif_project: convert_core_hif_project_spy
      )
    end
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

    it 'Return the status from find project' do
      expect(response[:status]).to eq('Draft')
    end

    context 'Given a hif project' do
      it 'Calls execute on the convert core hif project use case' do
        expect(convert_core_hif_project_spy).to have_received(:execute)
      end

      it 'Passes the project data to the converter' do
        expect(convert_core_hif_project_spy).to(
          have_received(:execute).with(
            project_data: { building1: 'a house' }
          )
        )
      end

      it 'Returns the converted data from find project' do
        expect(response[:data]).to eq(building2: 'a house')
      end
    end

    context 'Given a non hif project' do
      let(:find_project_spy) do
        spy(
          execute: {
            name: 'Big Buildings',
            type: 'ac',
            data: { building1: 'a house' },
            status: 'Draft'
          }
        )
      end

      it 'Does not execute the converted' do
        expect(convert_core_hif_project_spy).not_to have_received(:execute)
      end

      it 'Returns the original data' do
        expect(response[:data]).to eq(building1: 'a house')
      end
    end
  end

  describe 'Example 2' do
    let(:find_project_spy) do
      spy(
        execute: {
          name: 'Big ol woof',
          type: 'hif',
          data: { noise: 'bark' },
          status: 'Barking'
        }
      )
    end
    let(:convert_core_hif_project_spy) { spy(execute: { noiseMade: 'bark' }) }
    let(:use_case) do
      described_class.new(
        find_project: find_project_spy,
        convert_core_hif_project: convert_core_hif_project_spy
      )
    end
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
      expect(response[:type]).to eq('hif')
    end

    it 'Return the status from find project' do
      expect(response[:status]).to eq('Barking')
    end

    context 'Given a hif project' do
      it 'Calls execute on the convert core hif project use case' do
        expect(convert_core_hif_project_spy).to have_received(:execute)
      end

      it 'Passes the project data to the converter' do
        expect(convert_core_hif_project_spy).to(
          have_received(:execute).with(
            project_data: { noise: 'bark' }
          )
        )
      end

      it 'Returns the converted data from find project' do
        expect(response[:data]).to eq(noiseMade: 'bark')
      end
    end

    context 'Given a non hif project' do
      let(:find_project_spy) do
        spy(
          execute: {
            name: 'Big Buildings',
            type: 'cattos',
            data: { noise: 'bark' },
            status: 'Draft'
          }
        )
      end

      it 'Does not execute the converted' do
        expect(convert_core_hif_project_spy).not_to have_received(:execute)
      end

      it 'Returns the original data' do
        expect(response[:data]).to eq(noise: 'bark')
      end
    end
  end
end
