require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Updating a HIF Project' do
  include_context 'use case factory'

  before do
    ENV['PROJECT_FILE_PATH'] = '/tmp/projects.json'
    File.open(ENV['PROJECT_FILE_PATH'], 'w') {}
  end

  after do
    File.delete(ENV['PROJECT_FILE_PATH'])
  end

  it 'should update a project' do
    response = get_use_case(:create_new_project).execute(type: 'hif', baseline: { dogs: 'woof' })
    base_project = get_use_case(:find_project).execute(id: response[:id])
    expect(base_project.type).to eq('hif')
    expect(base_project.data[:dogs]).to eq('woof')

    success = get_use_case(:update_project).execute(id: response[:id], project: { type: 'new', baseline: { cats: 'meow' } })
    expect(success[:success]).to eq(true)
    updated_project = get_use_case(:find_project).execute(id: response[:id])

    expect(updated_project.type).to eq('new')
    expect(updated_project.data[:cats]).to eq('meow')
  end
end
