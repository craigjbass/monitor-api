# frozen_string_literal: true

require 'rspec'
require_relative 'delivery_mechanism_spec_helper'

describe 'Checking if Return is valid' do
  let(:check_api_key_spy) { spy }
  let(:api_key_gateway_spy) { nil }
  let(:api_key) { 'Cats' }

  let(:type) { 'hif' }
  let(:return_data) { { cats: 'in hats' } }
  let(:valid_response) { true }
  let(:invalid_paths) { [] }
  let(:validate_return_spy) do
    spy(execute: { valid: valid_response,
                   invalid_paths: invalid_paths })
  end
  before do
    stub_const(
      'LocalAuthority::UseCase::ValidateReturn',
      double(new: validate_return_spy)
    )

    stub_const(
      'LocalAuthority::UseCase::CheckApiKey',
      double(new: check_api_key_spy)
    )

    stub_const(
      'LocalAuthority::Gateway::InMemoryAPIKeyGateway',
      double(new: api_key_gateway_spy)
    )
  end

  context 'API key' do
    before do
      post '/return/validate', { type: type, returnData: return_data }.to_json, 'HTTP_API_KEY' => api_key
    end

    context 'is valid' do
      it 'responds with a 200' do
        expect(last_response.status).to eq(200)
      end
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

    context 'is invalid' do
      let(:check_api_key_spy) { spy(execute: {valid: false}) }

      it 'responds with a 401' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'is not in header' do
      it 'responds with a 400' do
        post '/return/create', { project_id: 1, data: { cats: 'Meow' } }.to_json
        expect(last_response.status).to eq(400)
      end
    end
  end
  context 'given valid data' do
    context 'given a valid return' do
      let(:invalid_paths) { [] }

      before do
        post '/return/validate', { type: type, returnData: return_data }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'will run validate return use case' do
        expect(validate_return_spy).to have_received(:execute).with(
          type: type,
          return_data: return_data
        )
      end

      it 'returns 200' do
        expect(last_response.status).to eq(200)
      end

      it 'returns json with valid set to true' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['valid']).to eq(true)
      end

      it 'returns json with invalidPaths as empty array' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['invalidPaths']).to eq([])
      end
    end

    context 'given invalid return' do
      let(:valid_response) { false }
      before do
        post '/return/validate', { type: type, returnData: return_data }.to_json, 'HTTP_API_KEY' => api_key
      end

      it 'will run validate return use case' do
        expect(validate_return_spy).to have_received(:execute).with(
          type: type,
          return_data: return_data
        )
      end

      it 'returns 200' do
        expect(last_response.status).to eq(200)
      end

      it 'returns json with valid set to false' do
        response_body = JSON.parse(last_response.body)
        expect(response_body['valid']).to eq(false)
      end

      context 'example one' do
        let(:invalid_paths) { [[:cathouses, 1, :catPlanning, :catPlanningNotGranted, :catInAHat, :hat]] }
        it 'returns json with correct invalidPaths' do
          response_body = JSON.parse(last_response.body)
          expect(response_body['invalidPaths']).to eq([['cathouses', 1, 'catPlanning', 'catPlanningNotGranted', 'catInAHat', 'hat']])
        end
      end

      context 'example two' do
        let(:invalid_paths) { [[:people, 99, :hello, :doggos, :boots]] }
        it 'returns json with correct invalidPaths' do
          response_body = JSON.parse(last_response.body)
          expect(response_body['invalidPaths']).to eq([['people', 99, 'hello', 'doggos', 'boots']])
        end
      end
    end
  end

  context 'given invalid data' do
    context 'with no type of data' do
      before do
        post '/return/validate', {}.to_json, 'HTTP_API_KEY' => api_key
      end
      it 'returns 400' do
        expect(last_response.status).to eq(400)
      end
    end

    context 'with no type' do
      before do
        post '/return/validate', { returnData: return_data }.to_json, 'HTTP_API_KEY' => api_key
      end
      it 'returns 400' do
        expect(last_response.status).to eq(400)
      end
    end

    context 'with no return data' do
      before do
        post '/return/validate', { type: type }.to_json, 'HTTP_API_KEY' => api_key
      end
      it 'returns 400' do
        expect(last_response.status).to eq(400)
      end
    end
  end
end
