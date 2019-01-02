# frozen_string_literal: true

describe 'expending an access token' do
  let(:export_project_all_spy) { spy(execute: returned_value) }

  before do
    stub_const(
      'HomesEngland::UseCase::ExportAllProjects',
      double(new: export_project_all_spy)
    )
    stub_const(
      'HomesEngland::UseCase::ExportProjectData',
      double(new: nil)
    )
    stub_const(
      'HomesEngland::Gateway::SequelProject',
      double(new: nil)
    )

    ENV['BI_HTTP_API_KEY'] = 'superSecret'
  end

  context 'invalid api key' do
    context 'example 1' do
      let(:returned_value) { {} }

      before do
        header 'API_KEY', 'cat'
        get '/projects/export'
      end

      it 'should respond with 401' do
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
        get '/projects/export'
      end

      it 'should respond with 401' do
        expect(last_response.status).to eq(401)
      end

      it 'should return an empty hash' do
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end
  end

  context 'with projects' do
    context 'example 1' do
      let(:returned_value) { { compiled_projects: [{ cats: 'meow' }] } }

      before do
        header 'API_KEY', ENV['BI_HTTP_API_KEY']
        get '/projects/export'
      end

      it 'executes the usecase' do
        expect(export_project_all_spy).to have_received(:execute)
      end

      it 'should respond with 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should respond with an accurate array of hashes' do
        response = Common::DeepSymbolizeKeys.to_symbolized_hash(
          JSON.parse(last_response.body)
        )
        expect(response).to eq({ projects: [{cats: 'meow'}] })
      end
    end

    context 'example 1' do
      let(:returned_value) { { compiled_projects: [{ cats: 'meow' }, {dogs: 'woof'}] } }

      before do
        header 'API_KEY', ENV['BI_HTTP_API_KEY']
        get '/projects/export'
      end

      it 'executes the usecase' do
        expect(export_project_all_spy).to have_received(:execute)
      end

      it 'should respond with 200' do
        expect(last_response.status).to eq(200)
      end

      it 'should respond with an accurate array of hashes' do
        response = Common::DeepSymbolizeKeys.to_symbolized_hash(
          JSON.parse(last_response.body)
        )
        expect(response).to eq({ projects: [{cats: 'meow'}, {dogs: 'woof'}] })
      end
    end
  end
end
