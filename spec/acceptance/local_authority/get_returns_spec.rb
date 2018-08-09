require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Getting multiple returns' do
  include_context 'use case factory'

  let(:returns_for_project_1) do
    [
      {
        id: 1,
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
        id: 2,
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
  end

  it 'can get multiple returns by project id from a gateway' do
    return1_id = get_use_case(:create_return).execute(
      project_id: 1, data: { cats: 'meow' }
    )[:id]

    get_use_case(:submit_return).execute(return_id: return1_id)

    return2_id = get_use_case(:create_return).execute(
      project_id: 1, data: { dogs: 'woof' }
    )[:id]

    expected_returns = [
      {
        id: return1_id,
        project_id: 1,
        updates: [
          { cats: 'meow' }
        ],
        status: 'Submitted'
      },
      {
        id: return2_id,
        project_id: 1,
        updates: [
          { dogs: 'woof' }
        ],
        status: 'Draft'
      }
    ]

    expect(get_use_case(:get_returns).execute(project_id: 1)[:returns]).to(
      eq(expected_returns)
    )
  end
end
