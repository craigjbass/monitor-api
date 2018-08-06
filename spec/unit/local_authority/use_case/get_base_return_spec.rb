
describe LocalAuthority::UseCase::GetBaseReturn do
    let(:return_gateway) {spy(find_by: schema)}
  let(:project_gateway_spy) { spy(find_by: project) }
  let(:use_case) do
    described_class.new(
      return_gateway: return_gateway,
      project_gateway: project_gateway_spy
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

    it 'will find the project in the Project Gateway' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
    end

    it 'will call find_by method on Return Gateway' do
      expect(return_gateway).to have_received(:find_by).with(type: project.type)
    end

    it 'will return a hash with correct id' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(id: project_id)
    end

    it 'will return a hash with correct baseline' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(data: data)
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

    it 'will find the project in the Project Gateway' do
      expect(project_gateway_spy).to have_received(:find_by).with(id: project_id)
    end

    it 'will call find_by method on Return Gateway' do
      expect(return_gateway).to have_received(:find_by).with(type: project.type)
    end

    it 'will return a hash with correct id' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(id: project_id)
    end

    it 'will return a hash with correct baseline' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(data: data)
    end

    it 'will return a hash with correct schema' do
      expect(use_case.execute(project_id: project_id)[:base_return]).to include(schema: schema.schema)
    end
  end
end
