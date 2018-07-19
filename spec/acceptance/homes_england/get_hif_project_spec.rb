require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Getting a HIF project' do
  include_context 'use case factory'

  before do
    ENV['PROJECT_FILE_PATH'] = '/tmp/projects.json'
    File.open(ENV['PROJECT_FILE_PATH'], 'w') {}
  end

  after do
    File.delete(ENV['PROJECT_FILE_PATH'])
  end

  it 'should find a project by its id' do
    response = get_use_case(:create_new_project).execute(type: 'hif',
                                                         baseline: { cats: 'meow' })
    project = get_use_case(:find_project).execute(id: response[:id])
    expect(project).to_not be_nil
    expect(project.type).to eq('hif')
    expect(project.data).to eq(cats: 'meow')
  end
end
