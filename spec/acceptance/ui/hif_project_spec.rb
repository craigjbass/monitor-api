# frozen_string_literal: true

require_relative '../shared_context/dependency_factory'

describe 'Interacting with a HIF Project from the UI' do
  include_context 'dependency factory'

  context 'Creating the project' do
    it 'Can create the project successfully' do
      project_id = dependency_factory.get_use_case(:ui_create_project).execute(
        type: 'hif',
        name: 'Cat Infrastructures',
        baseline: { cat: 'meow' }
      )[:id]

      created_project = dependency_factory.get_use_case(:ui_get_project).execute(
        id: project_id
      )

      expect(created_project[:type]).to eq('hif')
      expect(created_project[:name]).to eq('Cat Infrastructures')
      expect(created_project[:data]).to eq(cat: 'meow')
    end
  end
end
