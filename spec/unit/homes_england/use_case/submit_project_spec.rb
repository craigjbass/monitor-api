# frozen_string_literal: true

describe HomesEngland::UseCase::SubmitProject do
  describe 'When status is Draft' do
    let(:project_gateway) { spy(status: 'Draft') }
    let(:use_case) { described_class.new(project_gateway: project_gateway) }

    context 'Example 1' do
      it 'calls the submit method' do
        use_case.execute(project_id: 1)
        expect(project_gateway).to have_received(:submit).with(id: 1, status: 'LA Draft')
      end
    end

    context 'Example 2' do
      it 'calls the submit method' do
        use_case.execute(project_id: 7)
        expect(project_gateway).to have_received(:submit).with(id: 7, status: 'LA Draft')
      end
    end
  end

  describe 'When status is LA Draft' do
    let(:project_gateway) { spy(status: 'LA Draft') }
    let(:use_case) { described_class.new(project_gateway: project_gateway) }

    context 'Example 1' do
      it 'calls the submit method' do
        use_case.execute(project_id: 1)
        expect(project_gateway).to have_received(:submit).with(id: 1, status: 'Submitted')
      end
    end

    context 'Example 2' do
      it 'calls the submit method' do
        use_case.execute(project_id: 7)
        expect(project_gateway).to have_received(:submit).with(id: 7, status: 'Submitted')
      end
    end
  end
end
