# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Creating returns' do
  let(:create_return_spy) { spy(execute: { id: 0 }) }

  before do
      stub_const(
        'LocalAuthority::UseCase::CreateReturn',
        double(new: create_return_spy)
      )
  end

  it 'Will return a 400 if we pass invalid input' do
    post '/return/create', nil
    expect(last_response.status).to eq(400)
  end

  context 'with a single return' do
    context 'and valid input' do
      before do
        post '/return/create',
             { project_id: 1, data: { cats: 'Meow' } }.to_json, 'Content-Type' => 'application/json'
      end

      it 'passes data to CreateReturn' do
        expect(create_return_spy).to have_received(:execute).with(project_id: 1, data: {cats: 'Meow'})
      end

      it 'will return a 201' do
        expect(last_response.status).to eq(201)
      end

      it 'will return json with id' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['id']).to eq(0)
      end
    end
  end
end
