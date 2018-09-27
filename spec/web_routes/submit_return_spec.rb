require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Submitting a return' do
  let(:submit_return_spy) { spy(execute: nil) }

  before do
    stub_const(
      'LocalAuthority::UseCase::SubmitReturn',
      double(new: submit_return_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: {valid: true}))
    )
  end

  it 'submitting nothing should return 400' do
    post '/return/submit', nil, 'HTTP_API_KEY' => 'superSecret'
    expect(last_response.status).to eq(400)
  end

  it 'submitting a valid id should return 200' do
    post '/return/submit', {return_id: 1}.to_json, 'HTTP_API_KEY' => 'superSecret'
    expect(last_response.status).to eq(200)
  end

  context 'example one' do
    it 'will run submit return use case with id' do
      post '/return/submit', {return_id: 1}.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(submit_return_spy).to have_received(:execute).with(return_id: 1)
    end
  end


  context 'example two' do
    it 'will run submit return use case with id' do
      post '/return/submit', {return_id: 42}.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(submit_return_spy).to have_received(:execute).with(return_id: 42)
    end
  end
end
