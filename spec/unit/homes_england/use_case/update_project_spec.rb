require 'rspec'

describe HomesEngland::UseCase::UpdateProject do
  let(:use_case) { described_class.new(project_gateway: project_gateway_spy) }
  let(:response) {  use_case.execute(id: project_id, project_data: updated_project_data) }

  before { response }

  context 'example one' do
    let(:project_id) { 42 }
    let(:updated_project_data) {{ ducks: 'quack' }}

    context 'given a successful update' do
      let(:project_gateway_spy) do
        double(update: { success: true })
      end

      it 'Should pass the ID to the gateway' do
        expect(project_gateway_spy).to have_received(:update).with(
          hash_including(id: 42)
        )
      end

      it 'Should pass the project to the gateway' do
        expect(project_gateway_spy).to have_received(:update) do |request|
          project = request[:project]
          expect(project.data).to eq(ducks: 'quack')
        end
      end

      it 'Should return successful' do
        expect(response).to eq(successful: true)
      end

      it 'Should always pass a draft status to the gateway' do
        expect(project_gateway_spy).to have_received(:update) do |request|
          project = request[:project]
          expect(project.status).to eq('Draft')
        end
      end
    end

    context 'given an unsuccessful update' do
      let(:project_gateway_spy) do
        double(update: { success: false })
      end

      it 'Should return unsuccessful' do
        expect(response).to eq(successful: false)
      end
    end
  end

  context 'example two' do
    let(:project_id) { 123 }
    let(:updated_project_data) { { cows: 'moo' } }

    context 'given a successful update' do
      let(:project_gateway_spy) do
        double(update: { success: true })
      end

      it 'Should pass the ID to the gateway' do
        expect(project_gateway_spy).to have_received(:update).with(
          hash_including(id: 123)
        )
      end

      it 'Should pass the project to the gateway' do
        expect(project_gateway_spy).to have_received(:update) do |request|
          project = request[:project]
          expect(project.data).to eq(cows: 'moo')
        end
      end

      it 'Should return successful' do
        expect(response).to eq(successful: true)
      end

      it 'Should always pass a draft status to the gateway' do
        expect(project_gateway_spy).to have_received(:update) do |request|
          project = request[:project]
          expect(project.status).to eq('Draft')
        end
      end
    end

    context 'given an unsuccessful update' do
      let(:project_gateway_spy) do
        double(update: { success: false })
      end

      it 'Should return unsuccessful' do
        expect(response).to eq(successful: false)
      end
    end
  end
end
