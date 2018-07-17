require 'rspec'

describe HomesEngland::UseCase::CreateNewProject do
  let(:project_gateway) { double(create: project_id) }
  let(:use_case) { described_class.new(project_gateway: project_gateway) }
  let(:response) { use_case.execute(type: type, baseline: baseline) }

  before do
    response
  end

  context 'example one' do
    let(:project_id) { 0 }
    let(:type) { 'hif' }
    let(:baseline) { { key: 'value' } }


    it 'creates the project' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.type).to eq('hif')
        expect(project.data).to eq({ key: 'value' })
      end
    end

    it 'returns the id from the gateway' do
      expect(response).to eq({ id: 0 })
    end
  end

  context 'example two' do
    let(:project_id) { 42 }
    let(:type) { 'cats' }
    let(:baseline) { { cat: 'meow' } }

    it 'creates the project' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.type).to eq('cats')
        expect(project.data).to eq({ cat: 'meow' })
      end
    end

    it 'returns the id from the gateway' do
      expect(response).to eq({ id: 42 })
    end
  end
end