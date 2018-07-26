# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Updating a project' do
  let(:update_project_spy) { spy(execute: { successful: true }) }
  let(:create_new_project_spy) { spy(execute: project_id) }
  let(:project_id) { 1 }

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
    stub_const(
      'HomesEngland::UseCase::UpdateProject',
      double(new: update_project_spy)
    )

    stub_const(
      'HomesEngland::UseCase::CreateNewProject',
      double(new: create_new_project_spy)
    )
  end

  context 'with invalid' do
    context 'id' do
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

    context 'project' do
      context 'which is nil' do
        it 'should return 400' do
          post '/project/update', { id: project_id, project: nil }.to_json

          expect(last_response.status).to eq(400)
        end
      end
    end
  end

  context 'with valid id and project' do
    before do
      post '/project/update', {
        id: project_id,
        project: {
          type: new_project_data[:type],
          baselineData: new_project_data[:baselineData]
        }
      }.to_json
    end

    it 'should return 200' do
      expect(last_response.status).to eq(200)
    end

    it 'should update project data for id' do
      expect(update_project_spy).to(
        have_received(:execute).with(
          id: project_id,
          project: {
            type: 'new',
            baseline: { 'cats' => 'quack', 'dogs' => 'baa'}
          }
        )
      )
    end
  end
end
