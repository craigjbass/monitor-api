require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Getting multiple returns' do
  include_context 'use case factory'

  let(:returns_for_project_1) {
    [
      {
        project_id: 1,
        data:
        {
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
      },
      {
        project_id: 1,
        data:
        {
          summary: {
            project_name: 'Cats Embassy',
            description: 'Embassy for cats in the UK',
            lead_authority: 'Made Tech'
          },
          infrastructure: {
            type: 'Cat waiting room',
            description: 'A waiting room for cats',
            completion_date: '2019-09-01'
          },
          financial: {
            date: '2019-09-01',
            funded_through_HIF: true
          }
        }
      }

    ]
  }
  it 'can get multiple returns by project id from a gateway' do
    expect(get_use_case(:create_return).execute(project_id: 1, data:
      {
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
      }))

    expect(get_use_case(:create_return).execute(project_id: 1, data:
      {
        summary: {
          project_name: 'Cats Embassy',
          description: 'Embassy for cats in the UK',
          lead_authority: 'Made Tech'
        },
        infrastructure: {
          type: 'Cat waiting room',
          description: 'A waiting room for cats',
          completion_date: '2019-09-01'
        },
        financial: {
          date: '2019-09-01',
          funded_through_HIF: true
        }
      }))
    expect(get_use_case(:create_return).execute(project_id: 2, data:
      {
        summary: {
          project_name: 'Dog Protection League',
          description: 'A new headquarters for all the dogs',
          lead_authority: 'Made Tech'
        },
        infrastructure: {
          type: 'Dog Bathroom',
          description: 'Dog bathroom',
          completion_date: '2019-11-06'
        },
        financial: {
          date: '2019-12-06',
          funded_through_HIF: true
        }
      }))

    expect(get_use_case(:get_returns).execute(project_id: 1)).to eq(returns_for_project_1)
  end
end
