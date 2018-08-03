# frozen_string_literal: true

describe LocalAuthority::UseCase::SubmitReturn do
  let(:return_gateway) { spy }
  let(:use_case) {described_class.new(return_gateway: return_gateway)}
  context 'example 1' do
    it 'should submit an id to the return gateway' do
      use_case.execute(return_id: 1)
      expect(return_gateway).to have_received(:submit).with(return_id: 1)
    end
  end

  context 'example 2' do
    it 'should submit an id to the return gateway' do
      use_case.execute(return_id: 4)
      expect(return_gateway).to have_received(:submit).with(return_id: 4)
    end
  end
end
