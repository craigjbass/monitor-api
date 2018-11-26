# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::UpdateProject do
  let(:use_case) { described_class.new(project_gateway: project_gateway_spy) }
  let(:response) { use_case.execute(project_id: project_id, project_data: updated_project_data) }
  let(:la_project) { HomesEngland::Domain::Project.new }

  before do
    response
  end


  context 'example one' do
    let(:project_id) { 42 }
    let(:updated_project_data) { { ducks: 'quack' } }

    context 'given a successful update whilst in Draft status' do
      let(:la_project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.status = 'Draft'
          p.data = { a: 'b' }
        end
      end

      let(:project_gateway_spy) do
        spy(find_by: la_project, update: { success: true })
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

      it 'Should pass Draft status to the gateway' do
        expect(project_gateway_spy).to have_received(:update) do |request|
          project = request[:project]
          expect(project.status).to eq('Draft')
        end
      end
    end
  end

  context 'example two' do
    let(:project_id) { 123 }
    let(:updated_project_data) { { cows: 'moo' } }

    context 'given a successful update whilst in Draft status' do
      let(:la_project) do
        HomesEngland::Domain::Project.new.tap do |p|
          p.status = 'Draft'
          p.data = { b: 'c' }
        end
      end
      let(:project_gateway_spy) do
        spy(find_by: la_project, update: { success: true })
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

      it 'Should pass Draft status to the gateway' do
        expect(project_gateway_spy).to have_received(:update) do |request|
          project = request[:project]
          expect(project.status).to eq('Draft')
        end
      end
    end
  end
end
