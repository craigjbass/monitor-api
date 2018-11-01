# frozen_string_literal: true

describe UI::UseCase::CreateProject do
  context 'Example one' do
    let(:create_project_spy) { spy(execute: { id: 1 }) }
    let(:convert_ui_hif_project_spy) { spy(execute: { cattos: 'purr' }) }
    let(:use_case) do
      described_class.new(
        create_project: create_project_spy,
        convert_ui_hif_project: convert_ui_hif_project_spy
      )
    end
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

    it 'Returns the id from create project' do
      expect(response).to eq(id: 1)
    end

    context 'Given hif project' do
      it 'Calls execute on the convert use case' do
        expect(convert_ui_hif_project_spy).to have_received(:execute)
      end

      it 'Passes the project data to the converter' do
        expect(convert_ui_hif_project_spy).to have_received(:execute).with(
          project_data: { Cats: 'purr' }
        )
      end

      it 'Creates the project with the converted data' do
        expect(create_project_spy).to(
          have_received(:execute).with(hash_including(baseline: { cattos: 'purr' }))
        )
      end
    end

    context 'Given non hif project' do
      let(:response) do
        use_case.execute(type: 'laac', name: 'Cats', baseline: { Cats: 'purr' })
      end

      it 'Does not call execute on the convert use case' do
        expect(convert_ui_hif_project_spy).not_to have_received(:execute)
      end

      it 'Creates the project with the non-converted data' do
        expect(create_project_spy).to(
          have_received(:execute).with(hash_including(baseline: { Cats: 'purr' }))
        )
      end
    end
  end

  context 'Example two' do
    let(:create_project_spy) { spy(execute: { id: 5 }) }
    let(:convert_ui_hif_project_spy) { spy(execute: { dogs: 'woof' }) }
    let(:use_case) do
      described_class.new(
        create_project: create_project_spy,
        convert_ui_hif_project: convert_ui_hif_project_spy
      )
    end
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

    context 'Given hif project' do
      let(:response) do
        use_case.execute(type: 'hif', name: 'Dogs', baseline: { doggos: 'woof' })
      end

      it 'Calls execute on the convert use case' do
        expect(convert_ui_hif_project_spy).to have_received(:execute)
      end

      it 'Passes the project data to the converter' do
        expect(convert_ui_hif_project_spy).to have_received(:execute).with(
          project_data: { doggos: 'woof' }
        )
      end

      it 'Creates the project with the converted data' do
        expect(create_project_spy).to(
          have_received(:execute).with(hash_including(baseline: { dogs: 'woof' }))
        )
      end
    end

    context 'Given non hif project' do
      it 'Does not call execute on the convert use case' do
        expect(convert_ui_hif_project_spy).not_to have_received(:execute)
      end

      it 'Creates the project with the non-converted data' do
        expect(create_project_spy).to(
          have_received(:execute).with(hash_including(baseline: { doggos: 'woof' }))
        )
      end
    end
  end
end
