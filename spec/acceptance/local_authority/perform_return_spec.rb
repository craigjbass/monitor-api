# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Performing Return on HIF Project' do
  include_context 'use case factory'

  it 'should keep track of Returns' do
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


    get_response = get_use_case(:create_new_project).execute(
      type: 'hif', baseline: project_baseline
    )

    project = get_use_case(:project_gateway).find_by(id: get_response[:id])

    return_one_data = {
      project_id: get_response[:id],
      data: {
        summary: {
          project_name: 'Cats Protection League',
          description: 'A new headquarters for all the Cats',
          lead_authority: 'Made Tech',
          status: 'CATS!'
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
    }

    return_id_one = get_use_case(:create_return).execute(
      return_one_data
    )

    expect(get_use_case(:get_return).execute(return_id_one)).to eq(return_one_data)


    return_two_data = {
      project_id: get_response[:id],
      data: {
        summary: {
          project_name: 'Cats Protection League',
          description: 'A new headquarters for all the Cats',
          lead_authority: 'Made Tech',
          status: 'DOGS!'
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
    }

    return_id_two = get_use_case(:create_return).execute(
      return_two_data
    )

    expect(get_use_case(:get_return).execute(return_id_two)).to eq(return_two_data
                                                                )

    return_three_data = {
      project_id: get_response[:id],
      data: {
        summary: {
          project_name: 'Cats Protection League',
          description: 'A new headquarters for all the Cats',
          lead_authority: 'Made Tech',
          status: 'DUCKs!'
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
    }

    return_id_three = get_use_case(:create_return).execute(
      return_three_data
    )

    expect(get_use_case(:get_return).execute(return_id_three)).to eq(return_three_data)
  end
end
