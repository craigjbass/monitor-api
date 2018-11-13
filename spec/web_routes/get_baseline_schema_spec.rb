# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting a baseline schema' do
  before do
    stub_const(
      'HomesEngland::UseCase::GetSchemaForProject',
      double(new: get_baseline_schema_spy)
    )
    get "baseline/#{type}"
  end

  context 'given an existing baseline type' do
    context 'example 1' do
      let(:get_baseline_schema_spy) do
        double(
          execute: { cathouse: 'cats' }
        )
      end

      let(:type) { 'hif' }

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should execute GetSchemaForProject' do
        expect(get_baseline_schema_spy).to have_received(:execute).with(type: type)
      end

      it 'should return a baseline schema' do
        response = Common::DeepSymbolizeKeys.to_symbolized_hash(
          JSON.parse(last_response.body)
        )
        expect(response).to eq(cathouse: 'cats')
      end
    end

    context 'example 2' do
      let(:get_baseline_schema_spy) do
        double(
          execute: { doghouse: 'dogs' }
        )
      end

      let(:type) { 'hw35' }

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should pass a cache-control header' do
        expect(last_response.headers['Cache-Control']).to eq('no-cache')
      end

      it 'should execute GetSchemaForProject' do
        expect(get_baseline_schema_spy).to have_received(:execute).with(type: type)
      end

      it 'should return a baseline schema' do
        response = Common::DeepSymbolizeKeys.to_symbolized_hash(
          JSON.parse(last_response.body)
        )
        expect(response).to eq(doghouse: 'dogs')
      end
    end
  end

  context 'given a non-existent baseline type' do
    let(:get_baseline_schema_spy) do
      double(
        execute: nil
      )
    end

    let(:type) { 'tardis' }

    it 'should execute GetSchemaForProject' do
      expect(get_baseline_schema_spy).to have_received(:execute).with(type: type)
    end

    it 'should return 404' do
      expect(last_response.status).to eq(404)
    end
  end
end
