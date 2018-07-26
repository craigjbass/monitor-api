require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Getting a HIF project' do
  include_context 'use case factory'

  it 'should find a project by its id' do
    project_baseline = {
      summary: {
        project_name: 'Cats Protection League',
        description: 'A new headquarters for all the Cats',
        lead_authority: 'Made Tech'
      },
      infrastructure: {
        type: 'Cat Bathroom',
        description: 'Bathroom for Cats',
        completion_date: '2018-12-25'
      },
      financial: {
        date: '2017-12-25',
        funded_through_HIF: true
      }
    }

    expected_project = {
      summary: {
        project_name: 'Cats Protection League',
        description: 'A new headquarters for all the Cats',
        lead_authority: 'Made Tech',
        status: 'On Schedule'
      },
      infrastructure: {
        type: 'Cat Bathroom',
        description: 'Bathroom for Cats',
        completion_date: '2018-12-25'
      },
      financial: {
        date: '2017-12-25',
        funded_through_HIF: true
      }
    }

    response = get_use_case(:create_new_project).execute(type: 'hif',
                                                         baseline: project_baseline)
    project = get_use_case(:find_project).execute(id: response[:id])
    expect(project).to_not be_nil
    expect(project.type).to eq('hif')
    expect(project.data).to eq(expected_project)
  end
end
