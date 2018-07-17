describe HomesEngland::Gateway::FileProject do
  after do
    File.delete(file_path)
  end

  let(:gateway) do
    described_class.new(file_path: file_path)
  end

  context 'with a non existing file' do
    let(:file_path) { '/tmp/non-existent.json'}
    let(:project) do
      project = HomesEngland::Domain::Project.new
      project.type = 'hif'
      project.data = { cats: 'meow' }
      project
    end

    it 'does not throw an exception' do
      expect { gateway.create(project) }.not_to raise_error
    end

    it 'creates the project' do
      id = gateway.create(project)

      saved_project = gateway.find_by(id: id)
      expect(saved_project.type).to eq('hif')
      expect(saved_project.data).to eq({ cats: 'meow' })
    end
  end

  context 'with an existing file' do
    before do
      File.open(file_path, 'w') {}
    end

    context 'adding a single project' do
      context 'example one' do
        let(:file_path) { '/tmp/foo1.json' }

        it 'creates the project' do
          project = HomesEngland::Domain::Project.new
          project.type = 'hif'
          project.data = { cats: 'meow' }

          id = gateway.create(project)

          saved_project = gateway.find_by(id: id)
          expect(saved_project.type).to eq('hif')
          expect(saved_project.data).to eq({ cats: 'meow' })
        end
      end

      context 'example two' do
        let(:file_path) { '/tmp/foo2.json' }

        it 'creates the project' do
          project = HomesEngland::Domain::Project.new
          project.type = 'dogs'
          project.data = { dog: { go: 'woof' } }

          id = gateway.create(project)

          saved_project = gateway.find_by(id: id)
          expect(saved_project.type).to eq('dogs')
          expect(saved_project.data).to eq({ dog: { go: 'woof' } })
        end
      end
    end

    context 'adding multiple projects' do
      let(:file_path) { '/tmp/foo1.json' }

      it 'will not have matching ids' do
        project_cats = HomesEngland::Domain::Project.new
        project_cats.type = 'hif'
        project_cats.data = { cats: 'meow' }

        project_dogs = HomesEngland::Domain::Project.new
        project_dogs.type = 'dogs'
        project_dogs.data = { dogs: { noises: [{ smol: 'woof' }, { big: 'bark' }] } }

        id_cats = gateway.create(project_cats)
        id_dogs = gateway.create(project_dogs)

        saved_project_cats = gateway.find_by(id: id_cats)
        saved_project_dogs = gateway.find_by(id: id_dogs)

        expect(saved_project_dogs.type).to eq('dogs')
        expect(saved_project_dogs.data).to eq({ dogs: { noises: [{ smol: 'woof' }, { big: 'bark' }] } })

        expect(saved_project_cats.type).to eq('hif')
        expect(saved_project_cats.data).to eq({ cats: 'meow' })

      end
    end

    context 'find a project which does not exist' do
      let(:file_path) { '/tmp/foo.json' }

      it 'returns nil' do
        expect(gateway.find_by(id: 101)).to be_nil
      end
    end
  end
end