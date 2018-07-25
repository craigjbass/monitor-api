# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Creating a new HIF FileProject' do
  include_context 'use case factory'

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
        completion_date: '2018-12-25'
      },
      financial: {
        date: '2017-12-25',
        funded_through_HIF: true
      }
    }

    summary_with_status = {
      project_name: 'Cats Protection League',
      description: 'A new headquarters for all the Cats',
      lead_authority: 'Made Tech',
      status: 'On Schedule'
    }

    response = get_use_case(:create_new_project).execute(
      type: 'hif', baseline: project_baseline
    )

    project = get_use_case(:project_gateway).find_by(id: response[:id])

    expect(project.type).to eq('hif')
    expect(project.data[:summary]).to eq(summary_with_status)
    expect(project.data[:infrastructure]).to eq(project_baseline[:infrastructure])
    expect(project.data[:financial]).to eq(project_baseline[:financial])
  end
end
