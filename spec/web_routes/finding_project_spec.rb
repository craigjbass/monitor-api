require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Finding a project' do
  let(:project_data) do
    {
      type: 'hif',
      baselineData: {
        cats: 'meow',
        dogs: 'woof'
      }
    }
  end

  context 'with an invalid id' do
    let(:find_project_spy) { spy(execute: nil) }

    context 'example one' do
      let(:id) { 42 }

      before do
        stub_const(
          'HomesEngland::UseCase::FindProject',
          double(new: find_project_spy)
        )
        get '/project/find'
        { id: 99 }
      end

      it 'should should return 404' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'example two' do
      let(:id) { nil }

      before do
        stub_const(
          'HomesEngland::UseCase::FindProject',
          double(new: find_project_spy)
        )
        get '/project/find'
        { id: 99 }
      end

      it 'should should return 404' do
        expect(last_response.status).to eq(404)
      end
    end

    context 'example one' do
      let(:id) { 'Cats' }

      before do
        stub_const(
          'HomesEngland::UseCase::FindProject',
          double(new: find_project_spy)
        )
        get '/project/find'
        { id: 99 }
      end

      it 'should should return 404' do
        expect(last_response.status).to eq(404)
      end
    end
  end

  context 'with an valid id' do
    before do
      post '/project/create',
           project_data.to_json
      response_body = JSON.parse(last_response.body)
      get "/project/find?id=#{response_body['projectId']['id']}"
    end

    it 'should should return 200' do
      expect(last_response.status).to eq(200)
    end

    it 'should should have project in body' do
      response_body = JSON.parse(last_response.body)
      expect(response_body['type']).to eq('hif')
      expect(response_body['data']['cats']).to eq('meow')
      expect(response_body['data']['dogs']).to eq('woof')
    end
  end
end
