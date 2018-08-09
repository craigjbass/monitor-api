
describe LocalAuthority::UseCase::GetBaseReturn do
  let(:return_gateway) {spy(find_by: schema)}
  let(:project_gateway_spy) { spy(find_by: project) }
  let(:populate_return_spy) { spy(execute: populated_return) }
  let(:use_case) do
    described_class.new(
      return_gateway: return_gateway,
      project_gateway: project_gateway_spy,
      populate_return_template: populate_return_spy
    )
  end
  let(:response) { use_case.execute(project_id: project_id) }

  before { response }

  context 'example one' do
    let(:schema) do
      LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
        p.schema = {cats: 'meow'}
      end
    end
    let(:project_id) { 1 }
    let(:data) { { description: 'Super secret project' } }
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'hif'
        p.data = data
      end
    end
    let(:populated_return) { { populated_data: { cats: 'meow' } } }

    it 'will find the project in the Project Gateway' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
    end

    it 'will call find_by method on Return Gateway' do
      expect(return_gateway).to have_received(:find_by).with(type: project.type)
    end

    it 'will populate the return for the project' do
      expect(populate_return_spy).to have_received(:execute).with(type: project.type, baseline_data: project.data)
    end

    it 'will return a hash with correct id' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(id: project_id)
    end

    it 'will return a hash with populated return data' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(data: { cats: 'meow' })
    end

    it 'will return a hash with correct schema' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(schema: schema.schema)
    end
  end

  context 'example two' do
    let(:schema) { LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {dogs: 'woof'}
    end
    }
    let(:project_id) { 255 }
    let(:data) { { name: 'Extra secret project' } }
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'hif'
        p.data = data
      end
    end
    let(:populated_return) { { populated_data: { cows: 'moo' } } }


    it 'will find the project in the Project Gateway' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
    end

    it 'will call find_by method on Return Gateway' do
      expect(return_gateway).to have_received(:find_by).with(type: project.type)
    end

    it 'will populate the return for the project' do
      expect(populate_return_spy).to have_received(:execute).with(type: project.type, baseline_data: project.data)
    end

    it 'will return a hash with correct id' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(id: project_id)
    end

    it 'will return a hash with populated baseline' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(data: { cows: 'moo' })
    end

    it 'will return a hash with correct schema' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(schema: schema.schema)
    end
  end

  context 'given the type is not hif' do
    let(:schema) { LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {dogs: 'woof'}
    end
    }
    let(:project_id) { 255 }
    let(:data) { { name: 'Extra secret project' } }
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'woof'
        p.data = data
      end
    end
    let(:populated_return) { nil }

    it 'will not populate the return for the project' do
      expect(populate_return_spy).not_to have_received(:execute).with(type: project.type, baseline_data: project.data)
    end

    it 'will return a hash with project baseline data' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(data: project.data)
    end
  end
end
