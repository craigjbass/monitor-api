require 'rspec'

describe HomesEngland::UseCase::UpdateProject do
  let(:project_id) {42}
  let(:project_gateway_spy) {spy('find_by')}
  let(:use_case) {described_class.new(project_gateway: project_gateway_spy)}
  let(:updated_project) {{type: 'ABC', baseline: {ducks: 'quack'}}}

  context 'given id and project' do
    it 'should finds existing project' do
      use_case.execute(id: project_id, project: updated_project)
      expect(project_gateway_spy).to have_received(:find_by)
    end
  end
end
