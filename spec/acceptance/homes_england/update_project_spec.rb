require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Updating a HIF Project' do
  include_context 'dependency factory'

  it 'should update a project' do
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

    response = get_use_case(:create_new_project).execute(type: 'hif', baseline: project_baseline)
    success = get_use_case(:update_project).execute(id: response[:id], project_data: { cats: 'meow' })

    expect(success[:successful]).to eq(true)

    updated_project = get_use_case(:find_project).execute(id: response[:id])

    expect(updated_project[:type]).to eq('hif')
    expect(updated_project[:data][:cats]).to eq('meow')
  end

  context 'updating once submitted' do
    it 'should change the status back to draft' do
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

      response = get_use_case(:create_new_project).execute(type: 'hif', baseline: project_baseline)
      get_use_case(:submit_project).execute(project_id: response[:id])


      get_use_case(:update_project).execute(id: response[:id], project_data: { cats: 'meow' })

      updated_project = get_use_case(:find_project).execute(id: response[:id])

      expect(updated_project[:status]).to eq('Draft')
    end
  end
end
