require 'rspec'

describe HomesEngland::UseCase::UpdateProject do
  let(:use_case) { described_class.new(project_gateway: project_gateway_spy) }

  let(:updated_project) { { type: 'hif', baseline: { ducks: 'quack' } } }

  context 'given any id' do
    let(:project_id) { 42 }
    let(:project_gateway_spy) do
      double(update: { success: false })
    end

    it 'should use update on the project gateway' do
      use_case.execute(id: project_id, project: updated_project)
      expect(project_gateway_spy).to have_received(:update).with(
        id: 42, project: {
          type: 'hif', baseline:
          { ducks: 'quack' }
        }
      )
    end
  end

  context 'given a invalid' do
    context 'id' do
      let(:project_id) { 42 }
      let(:project_gateway_spy) do
        double(update: { success: false })
      end
      it 'return a hash with failure' do
        return_hash = use_case.execute(id: project_id, project: updated_project)
        expect(return_hash).to eq(success: false)
      end
    end

    context 'project' do
      context 'which is nil' do
        let(:updated_project) { nil }

        let(:project_id) { 42 }
        let(:project_gateway_spy) do
          double(update: { success: false })
        end
        it 'return a hash with failure' do
          return_hash = use_case.execute(
            id: project_id, project: updated_project
          )
          expect(return_hash).to eq(success: false)
        end
      end
      # Add later: 'which does not match schema'
    end
  end

  context 'given a valid id and project ' do
    let(:project_id) { 0 }
    let(:project_gateway_spy) do
      double(update: { success: true })
    end

    it 'return a hash with success' do
      return_hash = use_case.execute(
        id: project_id,
        project: updated_project
      )
      expect(return_hash).to eq(success: true)
    end
  end
end
