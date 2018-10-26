# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/dependency_factory'

describe 'Creating a new HIF FileProject' do
  include_context 'dependency factory'

  it 'should save project and return a unique id' do
    project_baseline = {
      summary: {
        project_name: 'Cats Protection League',
        description: 'A new headquarters for all the Cats',
        lead_authority: 'Made Tech'
      },
      infrastructure: {
        type: 'Cat Bathroom',
        description: 'Bathroom for Cats',
        completion_date: '2018-12-25',
        planning: {
          submission_estimated: '2018-01-01'
        }
      },
      financial: {
        total_amount_estimated: '£ 1,000,000.00'
      }
    }

    response = get_use_case(:create_new_project).execute(
      name: 'a project', type: 'hif', baseline: project_baseline
    )

    project = get_use_case(:find_project).execute(id: response[:id])

    expect(project[:type]).to eq('hif')
    expect(project[:data][:summary]).to eq(project_baseline[:summary])
    expect(project[:data][:infrastructure]).to eq(project_baseline[:infrastructure])
    expect(project[:data][:financial]).to eq(project_baseline[:financial])
  end

  it 'should have an initial status of draft' do
    project_baseline = {
      summary: {
        project_name: '',
        description: '',
        lead_authority: ''
      },
      infrastructure: {
        type: '',
        description: '',
        completion_date: '',
        planning: {
          submission_estimated: ''
        }
      },
      financial: {
        total_amount_estimated: ''
      }
    }
    response = get_use_case(:create_new_project).execute(
      name: 'a new project', type: 'hif', baseline: project_baseline
    )
    project = get_use_case(:find_project).execute(id: response[:id])
    expect(project[:status]).to eq('Draft')
  end
end
