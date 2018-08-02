require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Submitting a return' do
  let(:submit_return_spy) { spy(execute: nil) }

  before do
    stub_const(
      'LocalAuthority::UseCase::SubmitReturn',
      double(new: submit_return_spy)
    )
  end

  it 'submitting nothing should return 400' do
    post '/return/submit', nil
    expect(last_response.status).to eq(400)
  end

  it 'submitting a valid id should return 200' do
    post '/return/submit', {id: 1}.to_json
    expect(last_response.status).to eq(200)
  end

  context 'example one' do
    it 'will run submit return use case with id' do
      post '/return/submit', {id: 1}.to_json
      expect(submit_return_spy).to have_received(:execute).with(return_id: 1)
    end
  end


  context 'example two' do
    it 'will run submit return use case with id' do
      post '/return/submit', {id: 42}.to_json
      expect(submit_return_spy).to have_received(:execute).with(return_id: 42)
    end
  end

end
