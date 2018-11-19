# frozen-string-literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Submitting a project' do
  let(:submit_project_spy) { spy(execute: nil) }
  let(:notify_project_members_of_creation_spy) { spy }

  before do
    stub_const(
      'HomesEngland::UseCase::SubmitProject',
      double(new: submit_project_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )

    stub_const(
      'HomesEngland::UseCase::NotifyProjectMembersOfCreation',
      double(new: notify_project_members_of_creation_spy)
    )
  end

  context 'If API key is invalid' do
    let(:check_api_key_spy) { spy(execute: { valid: false })}

    it 'returns 401' do
      post 'project/submit', { project_id: '1' }.to_json, 'HTTP_API_KEY' => 'notSoSecret'

      expect(last_response.status).to eq(401)
    end
  end

  context 'If API key is valid' do
    let(:check_api_key_spy) { spy(execute: { valid: true })}

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

      it 'will run notify project members use case with id' do
        post '/project/submit', { project_id: '1', url: 'placeholder.com' }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(notify_project_members_of_creation_spy).to have_received(:execute).with(project_id: 1, url: 'placeholder.com')
      end
    end


    context 'example two' do
      it 'will run submit project use case with id' do
        post '/project/submit', { project_id: '5' }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(submit_project_spy).to have_received(:execute).with(project_id: 5)
      end

      it 'will run notify project members use case with id' do
        post '/project/submit', { project_id: '255', url: 'example.net' }.to_json, 'HTTP_API_KEY' => 'superSecret'
        expect(notify_project_members_of_creation_spy).to have_received(:execute).with(project_id: 255, url: 'example.net')
      end
    end
  end
end
