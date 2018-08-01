require 'rspec'

describe HomesEngland::UseCase::FindProject do
  let(:project_gateway) { double(find_by: project) }
  let(:use_case) { described_class.new(project_gateway: project_gateway) }
  let(:response) { use_case.execute(id: id) }

  before { response }

  context 'example one' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'hif'
        p.data = { dogs: 'woof' }
      end
    end
    let(:id) { 1 }

    it 'finds the project on the gateway' do
      expect(project_gateway).to have_received(:find_by).with(id: 1)
    end

    it 'returns a hash containing the projects type' do
      expect(response[:type]).to eq('hif')
    end

    it 'returns a hash containing the projects data' do
      expect(response[:data]).to eq(dogs: 'woof')
    end
  end

  context 'example two' do
    let(:project) do
      HomesEngland::Domain::Project.new.tap do |p|
        p.type = 'abc'
        p.data = { cats: 'meow' }
      end
    end
    let(:id) { 5 }

    it 'finds the project on the gateway' do
      expect(project_gateway).to have_received(:find_by).with(id: 5)
    end

    it 'returns a hash containing the projects type' do
      expect(response[:type]).to eq('abc')
    end

    it 'returns a hash containing the projects data' do
      expect(response[:data]).to eq(cats: 'meow')
    end
  end
end
