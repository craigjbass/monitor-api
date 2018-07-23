# frozen_string_literal: true

require 'rspec'

describe HomesEngland::UseCase::CreateNewProject do
  let(:populate_template_use_case) { double(execute: { populated_data: populated_data }) }
  let(:project_gateway) { double(create: project_id) }
  let(:use_case) do
    described_class.new(
      project_gateway: project_gateway,
      populate_template_use_case: populate_template_use_case
    )
  end
  let(:response) { use_case.execute(type: type, baseline: baseline) }

  before do
    response
  end

  context 'example one' do
    let(:project_id) { 0 }
    let(:type) { 'hif' }
    let(:baseline) { { key: 'value' } }
    let(:populated_data) { { key: 'newValue' } }

    it 'populate template with baseline data receives type baseline data ' do
      expect(populate_template_use_case).to have_received(:execute)
        .with(type: 'hif', baseline: baseline)
    end

    it 'creates the project with populated data' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.type).to eq('hif')
        expect(project.data).to eq(key: 'newValue')
      end
    end

    it 'returns the id from the gateway' do
      expect(response).to eq(id: 0)
    end
  end

  context 'example two' do
    let(:populated_data) { { key: 'veryNewValue' } }

    let(:project_id) { 42 }
    let(:type) { 'cats' }
    let(:baseline) { { cat: 'meow' } }

    it 'populate template with baseline data receives type baseline data ' do
      expect(populate_template_use_case).to have_received(:execute)
        .with(type: 'cats', baseline: baseline)
    end

    it 'creates the project' do
      expect(project_gateway).to have_received(:create) do |project|
        expect(project.type).to eq('cats')
        expect(project.data).to eq(key: 'veryNewValue')
      end
    end

    it 'returns the id from the gateway' do
      expect(response).to eq(id: 42)
    end
  end
end
