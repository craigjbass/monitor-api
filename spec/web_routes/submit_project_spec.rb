# frozen-string-literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Submitting a project' do
  let(:submit_project_spy) { spy(execute: nil) }

  before do
    stub_const(
      'HomesEngland::UseCase::SubmitProject',
      double(new: submit_project_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: double(execute: { valid: true }))
    )
  end

  it 'returns 400 when submitting nothing' do
    post 'project/submit', nil, 'HTTP_API_KEY' => 'superSecret'
    expect(last_response.status).to eq(400)
  end

  it 'returns 200 when submitting a valid id' do
    post 'project/submit', { project_id: '1' }.to_json, 'HTTP_API_KEY' => 'superSecret'
    expect(last_response.status).to eq(200)
  end

  context 'example one' do
    it 'will run submit project use case with id' do
      post '/project/submit', { project_id: '1' }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(submit_project_spy).to have_received(:execute).with(project_id: 1)
    end
  end

  context 'example two' do
    it 'will run submit project use case with id' do
      post '/project/submit', { project_id: '5' }.to_json, 'HTTP_API_KEY' => 'superSecret'
      expect(submit_project_spy).to have_received(:execute).with(project_id: 5)
    end
  end
end
