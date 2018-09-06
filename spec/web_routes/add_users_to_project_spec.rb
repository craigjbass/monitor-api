# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Adding users to a project' do
  let(:valid_admin_api_key) { 'supersecret' }

  before do
    ENV['ADMIN_HTTP_API_KEY'] = valid_admin_api_key
  end
  # context 'when incorrect admin http key provided' do
  #   let(:body) { { api_key: 'wrongkey', users: ['person1@mt.com'] } }
  #
  #   before do
  #     ENV['ADMIN_HTTP_API_KEY'] = 'supersecret'
  #   end
  #
  #   it 'returns 401' do
  #     post('project/1/add_users', body.to_json)
  #     expect(last_response.status).to eq(401)
  #   end
  # end

  context 'when no admin api key provided' do
    let(:body) { { users: ['person1@mt.com'] } }

    it 'returns 400' do
      post('project/1/add_users', body.to_json)
      expect(last_response.status).to eq(400)
    end
  end

  context 'when incorrect admin api key provided' do
    let(:body) { { admin_api_key: 'wrong_key', users: ['person1@mt.com'] } }

    it 'returns 401' do
      post('project/1/add_users', body.to_json)
      expect(last_response.status).to eq(401)
    end
  end

  context 'when request body is invalid' do
    context 'does not have users key' do
      let(:invalid_body) { { invalid_key: ['person1@mt.com'] } }

      it 'returns 400' do
        post('project/1/add_users', invalid_body.to_json)
        expect(last_response.status).to eq(400)
      end
    end

    context 'users key is not an array' do
      let(:invalid_body) { { users: 'person1@mt.com' } }

      it 'returns 400' do
        post('project/1/add_users', invalid_body.to_json)
        expect(last_response.status).to eq(400)
      end
    end

    context 'users array has no string containing non-whitespace characters' do
      let(:invalid_body) { { users: ['', '  '] } }

      it 'returns 400' do
        post('project/1/add_users', invalid_body.to_json)
        expect(last_response.status).to eq(400)
      end
    end

    context 'users array has no entries' do
      let(:invalid_body) { { users: [] } }

      it 'returns 400' do
        post('project/1/add_users', invalid_body.to_json)
        expect(last_response.status).to eq(400)
      end
    end
  end

  context 'when request body is valid' do
    let(:add_user_to_project_usecase_spy) { spy }
    let(:valid_request_body) { {admin_api_key: valid_admin_api_key, users: ['mt@mt.com'] } }

    before do
      stub_const(
        'HomesEngland::UseCase::AddUserToProject',
        double(new: add_user_to_project_usecase_spy)
      )
    end

    it 'returns 200' do
      post('project/1/add_users', valid_request_body.to_json)
      expect(last_response.status).to eq(200)
    end

    context 'when each entry in the body is non-empty' do
      let(:request_body) { { admin_api_key: valid_admin_api_key, users: ['mt1@mt1.com', 'mt2@mt2.com'] } }

      it 'execute AddUserToProject use case for each valid email' do
        post('project/33/add_users', request_body.to_json)
        expect(add_user_to_project_usecase_spy).to have_received(:execute).with(
          project_id: 33,
          email: 'mt1@mt1.com'
        )
        expect(add_user_to_project_usecase_spy).to have_received(:execute).with(
          project_id: 33,
          email: 'mt2@mt2.com'
        )
      end
    end

    context 'when not all entries are non-empty' do
      let(:request_body) { { admin_api_key: valid_admin_api_key, users: ['mt1@mt1.com', ' '] } }

      it 'only executes AddUserToProject for non-empty entries' do
        post('project/33/add_users', request_body.to_json)
        expect(add_user_to_project_usecase_spy).to have_received(:execute).once
      end
    end
  end
end
