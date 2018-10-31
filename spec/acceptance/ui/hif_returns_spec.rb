# frozen_string_literal: true

require_relative '../shared_context/dependency_factory'

describe 'Interacting with a HIF Return from the UI' do
  include_context 'dependency factory'

  let(:project_id) { create_project }
  let(:hif_baseline) do
    JSON.parse(
      File.open("#{__dir__}/../../fixtures/hif_baseline.json").read,
      symbolize_names: true
    )
  end
  let(:expected_updated_return) do
    JSON.parse(
      File.open("#{__dir__}/../../fixtures/hif_baseline.json").read,
      symbolize_names: true
    )
  end

  def create_project
    dependency_factory.get_use_case(:ui_create_project).execute(
      type: 'hif',
      name: 'Cat Infrastructures',
      baseline: hif_baseline
    )[:id]
  end

  before { project_id }

  context 'Creating a return' do
    it 'Allows you to create and view a return' do
      base_return = get_use_case(:ui_get_base_return).execute(project_id: project_id)[:base_return]
      return_data = base_return[:data].dup
      return_id = dependency_factory.get_use_case(:ui_create_return).execute(project_id: project_id, data: return_data)[:id]
      return_data[:infrastructures][0][:planning][:outlinePlanning][:planningSubmitted][:status] = 'Delayed'
      return_data[:infrastructures][0][:planning][:outlinePlanning][:planningSubmitted][:reason] = 'Distracted by kittens'
      dependency_factory.get_use_case(:ui_update_return).execute(return_id: return_id, data: return_data)

      created_return = dependency_factory.get_use_case(:ui_get_return).execute(return_id: return_id)

      expect(created_return).to eq(expected_updated_return)
    end
  end
end
