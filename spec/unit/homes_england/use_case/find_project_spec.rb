require 'rspec'

describe HomesEngland::UseCase::FindProject do
  let(:project_gateway) { double(find_by: project) }
  let(:use_case) { described_class.new(project_gateway: project_gateway) }
  let(:response) { use_case.execute(id: id) }

  context 'given an id' do
    let(:project) { { cats: 'meow' } }
    let(:id){42}
    it 'gateway find_by method is used' do
      expect(response).to eq({ cats: 'meow' })
    end
  end
end