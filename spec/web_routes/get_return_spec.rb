# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting returns' do
  let(:get_return_spy) { spy(execute: returned_hash) }
  let(:returned_hash) { { project_id: 1, data: { cats: 'Meow' } } }

  before do
      stub_const(
        'LocalAuthority::UseCase::GetReturn',
        double(new: get_return_spy)
      )
  end

  it 'response of 400 when id parameter does not exist' do

    get '/return/get'
    expect(last_response.status).to eq(400)
  end

  context 'Given one existing return' do
    before do
      get "/return/get?id=0"
    end

    it 'passes data to GetReturn' do
      expect(get_return_spy).to have_received(:execute).with(id: 0)
    end

    it 'responds with 200 when id found' do
      expect(last_response.status).to eq(200)
    end

    it 'returns the correct project_id' do
      response_body = JSON.parse(last_response.body)
      expect(response_body['project_id']).to eq(1)
    end
  end


  context "Nonexistent return" do
    let(:returned_hash) { {} }
    it 'responds with 404 when id not found' do
      get "/return/get?id=512"
      expect(last_response.status).to eq(404)
    end
  end
end
