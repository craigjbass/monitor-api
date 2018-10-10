# frozen_string_literal: true

describe HomesEngland::UseCase::SubmitProject do
  let(:project_gateway) { spy }
  let(:use_case) { described_class.new(project_gateway: project_gateway) }

  context 'Example 1' do
    it 'sets status to submitted upon submit' do
      use_case.execute(project_id: 1)
      expect(project_gateway).to have_received(:submit).with(id: 1)
    end
  end

  context 'Example 2' do
    it 'sets status to submitted upon submit' do
      use_case.execute(project_id: 7)
      expect(project_gateway).to have_received(:submit).with(id: 7)
    end
  end
end
