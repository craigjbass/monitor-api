# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Creating a new HIF FileProject' do
  include_context 'use case factory'

  before do
    ENV['PROJECT_FILE_PATH'] = '/tmp/projects.json'
    File.open(ENV['PROJECT_FILE_PATH'], 'w') {}
  end

  after do
    File.delete(ENV['PROJECT_FILE_PATH'])
  end

  it 'should save project and return a unique id' do
    project_baseline = {
      summary: {
        project_name: 'Cats Protection League',
        description: 'A new headquarters for all the Cats',
        lead_authority: 'Made Tech'
      },
      infrastructures: [
        {
          type: 'Cat Bathroom',
          description: 'Bathroom for Cats',
          completion_date: '2018-12-25'

        }
      ],
      financials: [
        {
          date: '2017-12-25',
          funded_through_HIF: true
        }
      ]
    }

    infrastructure_with_template_data_inserted = {
      type: 'Cat Bathroom',
      description: 'Bathroom for Cats',
      completion_date: '2018-12-25',
      completion_status: nil
    }

    response = get_use_case(:create_new_project).execute(
      type: 'hif', baseline: project_baseline
    )

    project = get_use_case(:project_gateway).find_by(id: response[:id])

    expect(project.type).to eq('hif')
    expect(project.data[:summary]).to eq(project_baseline[:summary])
    expect(project.data[:infrastructures].first).to eq(infrastructure_with_template_data_inserted)
    expect(project.data[:financials]).to eq(project_baseline[:financials])
  end
end
