# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe('Updating a project') do
  let(:existing_project_data) do
    {
      type: 'hif',
      baselineData: {
        cats: 'meow',
        dogs: 'woof'
      }
    }
  end

  let(:new_project_data) do
    {
      type: 'new',
      baselineData: {
        cats: 'quack',
        dogs: 'baa'
      }
    }
  end
  before do
    post '/project/create',
         existing_project_data.to_json
    response_body = JSON.parse(last_response.body)
    @valid_project_id = response_body['projectId']['id']
  end

  context 'with invalid' do
    context 'id' do
      context 'which is not in hash' do
        it 'should return 400' do
          post '/project/update',
               { id: 42,
                 project: {
                   type: new_project_data['type'],
                   baselineData: new_project_data['baselineData']
                 } }.to_json
          expect(last_response.status).to eq(400)
        end
      end
      context 'which is nil' do
        it 'should return 400' do
          post '/project/update',
               { id: nil,
                 project: {
                   type: new_project_data['type'],
                   baselineData: new_project_data['baselineData']
                 } }.to_json
          expect(last_response.status).to eq(400)
        end
      end
    end

    context 'project' do
      context 'which is nil' do
        it 'should return 400' do
          post '/project/update',
               { id: @valid_project_id, project: nil }.to_json
          expect(last_response.status).to eq(400)
        end
      end
      # Add later: 'which does not match schema'
    end
  end

  context 'with valid id and project' do
    it 'should return 202' do
      post '/project/update',
           { id: @valid_project_id,
             project: {
               type: new_project_data[:type],
               baselineData: new_project_data[:baselineData]
             } }.to_json
      expect(last_response.status).to eq(200)
    end

    it 'should update project data for id' do
      post '/project/update',
           { id: @valid_project_id,
             project: {
               type: new_project_data[:type],
               baselineData: new_project_data[:baselineData]
             } }.to_json
      expect(last_response.status).to eq(200)

      get "/project/find?id=#{@valid_project_id}"
      response_body = JSON.parse(last_response.body)
      expect(response_body['type']).to eq('new')
      expect(response_body['data']['cats']).to eq('quack')
      expect(response_body['data']['dogs']).to eq('baa')
    end
  end
end
