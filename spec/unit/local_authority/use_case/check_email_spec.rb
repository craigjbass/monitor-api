# frozen_string_literal: true

require 'rspec'

describe LocalAuthority::UseCase::CheckEmail do
  let(:use_case) { described_class.new(email_whitelist_gateway: email_whitelist_gateway_spy) }

  context 'calls the email_whitelist_gateway' do
    let(:email_whitelist_gateway_spy) { spy }
    it 'example 1' do
      use_case.execute(email_address: 'example@example.com')
      expect(email_whitelist_gateway_spy).to have_received(:find_by).with('example@example.com')
    end

    it 'example 2' do
      use_case.execute(email_address: 'hello@world.com')
      expect(email_whitelist_gateway_spy).to have_received(:find_by).with('hello@world.com')
    end
  end

  context 'returns a boolean' do
    context 'existent email' do
      let(:email_whitelist_gateway_spy) { spy(find_by: 0) }

      it 'returns true' do
        returned_hash = use_case.execute(email_address: 'example@example.com')
        expect(returned_hash).to eq(valid: true)
      end
    end

    context 'non-existent email' do
      let(:email_whitelist_gateway_spy) { spy(find_by: nil) }

      it 'returns false' do
        returned_hash = use_case.execute(email_address: 'example@example.com')
        expect(returned_hash).to eq(valid: false)
      end
    end
  end
end
