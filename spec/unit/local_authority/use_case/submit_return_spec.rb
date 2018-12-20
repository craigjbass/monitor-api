# frozen_string_literal: true

require 'timecop'

describe LocalAuthority::UseCase::SubmitReturn do
  let(:return_gateway) { spy }
  let(:use_case) { described_class.new(return_gateway: return_gateway) }
  context 'example 1' do
    it 'should submit an id and timestamp to the return gateway' do
      time_now = Time.now
      Timecop.freeze(time_now)
      time_now = time_now.to_i
      use_case.execute(return_id: 1)
      expect(return_gateway).to have_received(:submit).with(return_id: 1, timestamp: time_now)
    end
  end

  context 'example 2' do
    it 'should submit an id and timestamp to the return gateway' do
      time_now = Time.now
      Timecop.freeze(time_now)
      time_now = time_now.to_i
      use_case.execute(return_id: 4)
      expect(return_gateway).to have_received(:submit).with(return_id: 4, timestamp: time_now)
    end
  end
end
