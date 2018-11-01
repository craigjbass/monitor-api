# frozen_string_literal: true

require 'rspec'

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Updating a return' do
  let(:update_return_spy) do
    spy
  end

  before do
    stub_const(
      'UI::UseCase::UpdateReturn',
      double(new: update_return_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: {valid: true}))
    )
  end

  context 'with invalid' do
    it 'return data' do
      post '/return/update', { return_id: 1, return_data: nil }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(400)
    end
    it 'return id' do
      post '/return/update', { return_id: nil, return_data: {} }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(400)
    end
  end

  context 'with valid input data' do
    it 'return 200' do
      post '/return/update', { return_id: 1, return_data: {} }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(last_response.status).to eq(200)
    end

    context 'example one' do
      it 'will run update return use case' do
        post '/return/update', { return_id: 1, return_data: { cats: 'meow' } }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(update_return_spy).to have_received(:execute).with(
          return_id: 1, return_data: { cats: 'meow' }
        )
      end
    end

    context 'example two' do
      it 'will run update return use case' do
        post '/return/update', { return_id: 1, return_data: { dogs: 'woof' } }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(update_return_spy).to have_received(:execute).with(
          return_id: 1, return_data: { dogs: 'woof' }
        )
      end
    end
  end
end
