# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting a return' do
  let(:get_return_spy) { spy(execute: returned_hash) }
  let(:get_schema_for_return_spy) { spy(execute: returned_schema) }
  let(:returned_hash) { { project_id: 1, updates: [{ cats: 'Meow' }], status: 'Draft' } }
  let(:returned_schema) { { schema: { cats: 'string' } } }

  before do
    stub_const(
      'LocalAuthority::UseCase::GetReturn',
      double(new: get_return_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::GetSchemaForReturn',
      double(new: get_schema_for_return_spy)
    )
  end

  it 'response of 400 when id parameter does not exist' do
    get '/return/get'
    expect(last_response.status).to eq(400)
  end

  context 'Given one existing return' do
    before do
      get '/return/get?id=0'
    end

    it 'passes data to GetReturn' do
      expect(get_return_spy).to have_received(:execute).with(id: 0)
    end

    it 'passes data to GetSchemaForReturn' do
      expect(get_schema_for_return_spy).to(
        have_received(:execute).with(return_id: 0)
      )
    end

    it 'responds with 200 when id found' do
      expect(last_response.status).to eq(200)
    end

    it 'returns the correct project_id' do
      response_body = JSON.parse(last_response.body)
      expect(response_body['project_id']).to eq(1)
    end

    it 'returns the correct data' do
      response_body = JSON.parse(last_response.body)
      expect(response_body['data']).to eq('cats' => 'Meow')
    end

    it 'returns the correct schema' do
      response_body = JSON.parse(last_response.body)
      expect(response_body['schema']).to eq('cats' => 'string')
    end

    it 'returns the correct schema' do
      response_body = JSON.parse(last_response.body)
      expect(response_body['status']).to eq('Draft')
    end
  end

  context 'Nonexistent return' do
    let(:returned_hash) { {} }
    it 'responds with 404 when id not found' do
      get '/return/get?id=512'
      expect(last_response.status).to eq(404)
    end
  end
end
