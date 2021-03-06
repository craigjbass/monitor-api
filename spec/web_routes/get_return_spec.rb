# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting a return' do
  let(:get_return_spy) { spy(execute: returned_hash) }
  let(:get_schema_for_return_spy) { spy(execute: returned_schema) }
  let(:type) { '' }
  let(:returned_hash) { { project_id: 1, type: type, updates: [{ cats: 'Meow' }], status: 'Draft' , no_of_previous_returns: 2} }
  let(:returned_schema) { { schema: { cats: 'string' } } }

  before do
    stub_const(
      'UI::UseCase::GetReturn',
      double(new: get_return_spy)
    )

    stub_const(
      'UI::UseCase::GetSchemaForReturn',
      double(new: get_schema_for_return_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: {valid: true}))
    )

    header 'API_KEY', 'superSecret'
  end

  it 'response of 400 when id parameter does not exist' do
    get '/return/get'
    expect(last_response.status).to eq(400)
  end

  context 'Given one existing return' do
    context 'example 1' do
      let(:type) { 'ac' }

      let(:response_body) { JSON.parse(last_response.body) }

      before do
        get '/return/get?id=0&returnId=1'
      end

      it 'passes data to GetReturn' do
        expect(get_return_spy).to have_received(:execute).with(id: 1)
      end

      it 'passes data to UIGetSchemaForReturn' do
        expect(get_schema_for_return_spy).to(
          have_received(:execute).with(return_id: 1)
        )
      end

      it 'responds with 200 when id found' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'returns the correct project_id' do
        expect(response_body['project_id']).to eq(1)
      end

      it 'returns the correct type' do
        expect(response_body['type']).to eq('ac')
      end

      it 'returns the correct data' do
        expect(response_body['data']).to eq('cats' => 'Meow')
      end

      it 'returns the correct schema' do
        expect(response_body['schema']).to eq('cats' => 'string')
      end

      it 'returns the correct schema' do
        expect(response_body['status']).to eq('Draft')
      end

      it 'returns the correct schema' do
        expect(response_body['no_of_previous_returns']).to eq(2)
      end
    end

    context 'example 2' do
      let(:type) { 'hif' }

      let(:response_body) { JSON.parse(last_response.body) }

      before do
        get '/return/get?id=0&returnId=1'
      end

      it 'passes data to GetReturn' do
        expect(get_return_spy).to have_received(:execute).with(id: 1)
      end

      it 'passes data to GetSchemaForReturn' do
        expect(get_schema_for_return_spy).to(
          have_received(:execute).with(return_id: 1)
        )
      end

      it 'responds with 200 when id found' do
        expect(last_response.status).to eq(200)
      end

      it 'returns the correct project_id' do
        expect(response_body['project_id']).to eq(1)
      end

      it 'returns the correct type' do
        expect(response_body['type']).to eq('hif')
      end

      it 'returns the correct data' do
        expect(response_body['data']).to eq('cats' => 'Meow')
      end

      it 'returns the correct schema' do
        expect(response_body['schema']).to eq('cats' => 'string')
      end

      it 'returns the correct schema' do
        expect(response_body['status']).to eq('Draft')
      end

      it 'returns the correct schema' do
        expect(response_body['no_of_previous_returns']).to eq(2)
      end
    end
  end

  context 'Nonexistent return' do
    let(:returned_hash) { {} }
    it 'responds with 404 when id not found' do
      get '/return/get?id=0&returnId=512'
      expect(last_response.status).to eq(404)
    end
  end
end
