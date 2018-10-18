# frozen_string_literal: true

describe 'expending an access token' do
  let(:compile_project_spy) { spy(execute: returned_value) }

  before do
    stub_const(
      'HomesEngland::UseCase::CompileProject',
      double(new: compile_project_spy)
    )
    stub_const(
      'LocalAuthority::UseCase::GetReturns',
      double(new: nil)
    )
    stub_const(
      'HomesEngland::UseCase::FindProject',
      double(new: nil)
    )

    ENV['BI_HTTP_API_KEY'] = 'superSecret'
  end

  context 'invalid api key' do
    context 'example 1' do
      let(:returned_value) { {} }

      before do
        header 'API_KEY', 'cat'
        get '/project/25565/export'
      end

      it 'should respond with 403' do
        expect(last_response.status).to eq(401)
      end

      it 'should return an empty hash' do
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end

    context 'example 2' do
      let(:returned_value) { {} }

      before do
        header 'API_KEY', 'dog'
        get '/project/64/export'
      end

      it 'should respond with 403' do
        expect(last_response.status).to eq(401)
      end

      it 'should return an empty hash' do
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end
  end

  context 'non-existent project' do
      let(:returned_value) { {} }

      before do
        header 'API_KEY', ENV['BI_HTTP_API_KEY']
        get '/project/4096/export'
      end

      it 'should respond with 404' do
        expect(last_response.status).to eq(404)
      end

      it 'should return an empty hash' do
        expect(JSON.parse(last_response.body)).to eq({})
      end
  end

  context 'existing project' do
    context 'example 1' do
      let(:returned_value) { { compiled_project: { cats: 'meow' } } }

      before do
        header 'API_KEY', ENV['BI_HTTP_API_KEY']
        get '/project/1/export'
      end

      it 'passes the correct id to the use case' do
        expect(compile_project_spy).to have_received(:execute).with(project_id: 1)
      end

      it 'should respond with 200 for a project that exists' do
        expect(last_response.status).to eq(200)
      end

      it 'should respond with an accurate array of hashes' do
        response = Common::DeepSymbolizeKeys.to_symbolized_hash(
          JSON.parse(last_response.body)
        )
        expect(response).to eq(cats: 'meow')
      end
    end

    context 'example 2' do
      let(:returned_value) { { compiled_project: { dogs: 'woof' } } }

      before do
        header 'API_KEY', ENV['BI_HTTP_API_KEY']
        get '/project/255/export'
      end

      it 'passes the correct id to the use case' do
        expect(compile_project_spy).to have_received(:execute).with(project_id: 255)
      end

      it 'should respond with 200 for a project that exists' do
        expect(last_response.status).to eq(200)
      end

      it 'should respond with an accurate array of hashes' do
        response = Common::DeepSymbolizeKeys.to_symbolized_hash(
          JSON.parse(last_response.body)
        )
        expect(response).to eq(dogs: 'woof')
      end
    end
  end
end
