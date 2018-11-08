# frozen_string_literal: true

describe UI::UseCase::GetBaseReturn do
  context 'Example one' do
    let(:convert_core_return_spy) { spy }
    let(:get_base_return_spy) { spy(execute: { base_return: { cat: 'meow' } }) }
    let(:use_case) do
      described_class.new(
        get_base_return: get_base_return_spy,
        find_project: find_project_spy,
        convert_core_hif_return: convert_core_return_spy
      )
    end
    let(:response) { use_case.execute(project_id: 4) }
    let(:find_project_spy) { spy(execute: { type: 'nothif' }) }

    before { response }

    it 'Calls execute on the get base return usecase' do
      expect(get_base_return_spy).to have_received(:execute)
    end

    it 'Passes the project ID to get base return' do
      expect(get_base_return_spy).to have_received(:execute).with(project_id: 4)
    end

    it 'Returns the base return from get base return' do
      expect(response).to eq(base_return: { cat: 'meow' })
    end

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 4)
    end

    context 'Hif type' do
      let(:find_project_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_core_return_spy) { spy(execute: { cow: 'moo' }) }

      it 'Calls the convert core return use case with the data' do
        expect(convert_core_return_spy).to have_received(:execute).with(return_data: { cat: 'meow' })
      end

      it 'returns converted data' do
        expect(response).to eq(base_return: { cow: 'moo' })
      end
    end

    context 'NON HIF type' do
      it 'doesnt call the convert core use case' do
        expect(convert_core_return_spy).not_to have_received(:execute)
      end
    end
  end

  context 'Example two' do
    let(:find_project_spy) { spy(execute: { type: 'comethingelse' }) }
    let(:convert_core_return_spy) { spy }
    let(:get_base_return_spy) { spy(execute: { base_return: { dog: 'woof' } }) }
    let(:use_case) do
      described_class.new(
        get_base_return: get_base_return_spy,
        find_project: find_project_spy,
        convert_core_hif_return: convert_core_return_spy
      )
    end
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

    it 'Calls the find project use case' do
      expect(find_project_spy).to have_received(:execute).with(id: 7)
    end

    context 'Hif type' do
      let(:find_project_spy) { spy(execute: { type: 'hif' }) }
      let(:convert_core_return_spy) { spy(execute: { ducks: 'quack' }) }

      it 'Calls the convert core return use case with the data' do
        expect(convert_core_return_spy).to have_received(:execute).with(return_data: { dog: 'woof' })
      end

      it 'returns converted data' do
        expect(response).to eq(base_return: { ducks: 'quack' })
      end
    end

    context 'Non HIF type' do
      it 'doesnt call the convert core use case' do
        expect(convert_core_return_spy).not_to have_received(:execute)
      end
    end
  end
end
