# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::UpdateProject do
  context 'first update' do 
    let(:use_case) { described_class.new(project_gateway: project_gateway_spy) }
    let(:response) do
      use_case.execute(
        project_id: project_id,
        project_data: updated_project_data,
        timestamp: timestamp
      )
    end
    let(:time_now) { Time.now }

    let(:la_project) { HomesEngland::Domain::Project.new }
  
    before do
      Timecop.freeze(time_now)
      response
    end

    after do
      Timecop.return
    end
  
  
    context 'example one' do
      let(:project_id) { 42 }

      let(:updated_project_data) { { ducks: 'quack' } }
  
      context 'given a successful update whilst in Draft status' do
        let(:timestamp) { 0 }
        let(:la_project) do
          HomesEngland::Domain::Project.new.tap do |p|
            p.status = 'Draft'
            p.data = { a: 'b' }
            p.timestamp = 0
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
  
        it 'Should return successful, no errors and timestamp' do
          expect(response).to eq(successful: true, errors:[], timestamp: time_now.to_i)
        end
  
        it 'Should pass Draft status to the gateway' do
          expect(project_gateway_spy).to have_received(:update) do |request|
            project = request[:project]
            expect(project.status).to eq('Draft')
          end
        end
      end

      context 'given an incorrect timestamp' do
        let(:timestamp) { 0 }

        let(:la_project) do
          HomesEngland::Domain::Project.new.tap do |p|
            p.status = 'Draft'
            p.data = { a: 'b' }
            p.timestamp = 5
          end
        end
  
        let(:project_gateway_spy) do
          spy(find_by: la_project, update: { success: true })
        end

        it 'does not pass the data to the gateway' do 
          expect(project_gateway_spy).not_to have_received(:update)
        end

        it 'returns unsuccessful' do
          expect(response[:successful]).to eq(false)
        end

        it 'returns an incorrect timestamp error' do
          expect(response[:errors]).to eq([:incorrect_timestamp])
        end

        it 'returns an unchanged timestamp' do
          expect(response[:timestamp]).to eq(0)
        end
      end
    end
    
    context 'example two' do
      let(:project_id) { 123 }
      let(:updated_project_data) { { cows: 'moo' } }
      
      context 'given a successful update whilst in Draft status' do
        let(:timestamp) { 0 }
        let(:la_project) do
          HomesEngland::Domain::Project.new.tap do |p|
            p.status = 'Draft'
            p.data = { b: 'c' }
            p.timestamp = 0
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
          expect(response).to eq(successful: true, errors:[], timestamp: time_now.to_i)
        end
  
        it 'Should pass Draft status to the gateway' do
          expect(project_gateway_spy).to have_received(:update) do |request|
            project = request[:project]
            expect(project.status).to eq('Draft')
          end
        end
      end

      context 'given an incorrect timestamp' do
        let(:timestamp) { 4 }

        let(:la_project) do
          HomesEngland::Domain::Project.new.tap do |p|
            p.status = 'Draft'
            p.data = { c: 'd' }
            p.timestamp = 9
          end
        end
  
        let(:project_gateway_spy) do
          spy(find_by: la_project, update: { success: true })
        end

        it 'does not pass the data to the gateway' do 
          expect(project_gateway_spy).not_to have_received(:update)
        end

        it 'returns unsuccessful' do
          expect(response[:successful]).to eq(false)
        end

        it 'returns an incorrect timestamp error' do
          expect(response[:errors]).to eq([:incorrect_timestamp])
        end

        it 'returns an unchanged timestamp' do
          expect(response[:timestamp]).to eq(4)
        end
      end
    end
  end

  context 'second update' do
    it 'Increases the timestamp' do
      time_now = Time.now
      Timecop.freeze(time_now)
      new_time = time_now.to_i - 1

      current_project = HomesEngland::Domain::Project.new.tap do |p|
          p.status = 'Draft'
          p.data = { a: 'b' }
          p.timestamp = new_time
        end
  
      project_gateway_spy = spy(find_by: current_project, update: { success: true })
      
      use_case = described_class.new(project_gateway: project_gateway_spy)

      response = use_case.execute(
        project_id: 4,
        project_data: { ducks: 'Quack'},
        timestamp: new_time
      )
  
      expect(project_gateway_spy).to have_received(:update) do |request|
        project = request[:project]
        expect(project.timestamp).to be > new_time
      end

      Timecop.return
    end
  end
end
