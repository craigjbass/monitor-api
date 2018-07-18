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

  let(:updated_project){
    {
      type: 'new',
      baseline: {
        cats:'meow'
      }
    }
  }
  it 'should update a project' do
    response = get_use_case(:create_new_project).execute(type: 'hif', baseline: { dogs:'woof'})
    intial_project = get_use_case(:find_project).execute(id: response[:id])

    get_use_case(:update_project).execute(id: response[:id], project: updated_project)
    updated_project = get_use_case(:find_project).execute(id: response[:id])

    expect(intial_project['type']).to eq('hif')
    expect(intial_project['baseline']['dogs']).to eq('woof')

    expect(updated_project['type']).to eq('new')
    expect(updated_project['baseline']['cats']).to eq('meow')
    true.should == false
  end
end