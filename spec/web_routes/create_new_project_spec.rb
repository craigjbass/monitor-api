# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Creating a new project' do
  let(:create_new_project_spy) { spy(execute: project_id) }

  let(:check_api_key_spy) { spy }

  let(:api_key_gateway_spy) { nil }

  let(:api_key) { 'Cats' }

  before do
    stub_const(
      'HomesEngland::UseCase::CreateNewProject',
      double(new: create_new_project_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )

    stub_const(
      'LocalAuthority::Gateway::InMemoryAPIKeyGateway',
      double(new: api_key_gateway_spy)
    )
    post('/project/create', project_data.to_json, 'HTTP_API_KEY' => api_key)
  end

  context 'example one' do
    let(:project_id) { 1 }
    let(:project_data) do
      {
        type: 'hif',
        baselineData: {
          cats: 'meow',
          dogs: 'woof'
        }
      }
    end

    context 'API Key' do
      context 'is valid' do
        it 'responds with a 201' do
          expect(last_response.status).to eq(201)
        end

        context 'example 1' do
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Cats')
          end
        end

        context 'example 2' do
          let(:api_key) { 'Dogs' }
          it 'runs the check api key use case' do
            expect(check_api_key_spy).to have_received(:execute).with(api_key: 'Dogs')
          end
        end
      end

      context 'is invalid' do
        let(:check_api_key_spy) { spy(execute: {valid: false}) }

        it 'responds with a 401' do
          expect(last_response.status).to eq(401)
        end
      end

      context 'is not in header' do
        it 'responds with a 400' do
          post('/project/create', project_data.to_json)
          expect(last_response.status).to eq(400)
        end
      end
    end

    it 'should call the create_new_project use case' do
      expect(create_new_project_spy).to have_received(:execute)
    end

    it 'should call the create_new_project use case with type' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(type: 'hif')
        )
      )
    end

    it 'should create new project with baseline data' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(baseline: { cats: 'meow', dogs: 'woof' })
        )
      )
    end

    it 'should return the id of the project' do
      response_body = JSON.parse(last_response.body)

      expect(response_body['projectId']).to eq(project_id)
    end
  end

  context 'example two' do
    let(:project_id) { 42 }
    let(:project_data) do
      {
        type: 'ac',
        baselineData: {
          ducks: 'quack',
          good: [
            {
              dogs: 'yes',
              wasps: 'no'
            }
          ]
        }
      }
    end

    it 'should return a 201 response' do
      expect(last_response.status).to eq(201)
    end

    it 'should call the create_new_project use case' do
      expect(create_new_project_spy).to have_received(:execute)
    end

    it 'should call the create_new_project use case with type' do
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(type: 'ac')
        )
      )
    end

    it 'should create new project with baseline data' do
      expected_baseline = {
        ducks: 'quack',
        good: [
          {
            dogs: 'yes',
            wasps: 'no'
          }
        ]
      }
      expect(create_new_project_spy).to(
        have_received(:execute).with(
          hash_including(baseline: expected_baseline)
        )
      )
    end

    it 'should return the id of the project' do
      response_body = JSON.parse(last_response.body)

      expect(response_body['projectId']).to eq(project_id)
    end
  end
end
