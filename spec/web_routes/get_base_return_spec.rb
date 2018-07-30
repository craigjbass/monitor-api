# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Getting a base return' do
  let(:get_base_return_spy) { spy(execute: base_return) }

  before do
    stub_const(
      'LocalAuthority::UseCase::GetBaseReturn',
      double(new: get_base_return_spy)
    )
  end

  context 'given no matching project id' do
    let (:project_id) { 1337 }
    let(:get_base_return_spy) { spy(execute: base_return) }
    let(:base_return) { {} }

    before do
      get "/project/#{project_id}/return"
    end
    it 'should return 404' do
      expect(last_response.status).to eq(404)
    end
  end

  context 'given an existing project id' do
    context 'example one' do
      let (:project_id) { 42 }
      let(:base_return) do
        {
          base_return: {
            dogs: 'woof',
            cats: 'meow'
          }
        }
      end

      before do
        get "/project/#{project_id}/return"
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should run the get base return use case' do
        expect(get_base_return_spy).to have_received(:execute)
      end

      it 'should pass the project id to the find base return use case' do
        expect(get_base_return_spy).to have_received(:execute).with(project_id: project_id)
      end

      it 'return a hash with correct base return data' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['baseReturn']['dogs']).to eq('woof')
        expect(response_body['baseReturn']['cats']).to eq('meow')
      end
    end

    context 'example two' do
      let (:project_id) { 99 }

      let(:base_return) do
        {
          base_return: {
            moomin_one: 'Papa Moomin',
            moomin_two: 'Mama Moomin'
          }
        }
      end

      before do
        get "/project/#{project_id}/return"
      end

      it 'should return 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should run the get base return use case' do
        expect(get_base_return_spy).to have_received(:execute)
      end

      it 'should pass the project id to the find base return use case' do
        expect(get_base_return_spy).to have_received(:execute).with(
          project_id: project_id
        )
      end

      it 'return a hash with correct base return data' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['baseReturn']['moomin_one']).to eq('Papa Moomin')
        expect(response_body['baseReturn']['moomin_two']).to eq('Mama Moomin')
      end
    end
  end
end
