# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Creating a new project' do
  include_context 'as admin'

  let(:create_new_project_spy) { spy(execute: project_id) }

  before do
    set_correct_auth_header

    stub_const(
      'HomesEngland::UseCase::CreateNewProject',
      double(new: create_new_project_spy)
    )

    post('/project/create', project_data.to_json)
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
