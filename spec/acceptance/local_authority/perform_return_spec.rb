# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Performing Return on HIF Project' do
  include_context 'use case factory'

  def create_new_return(return_data)
    get_use_case(:create_return).execute(return_data)[:id]
  end

  def expect_return_with_id_to_equal(id:, expected_return:)
    found_return = get_use_case(:get_return).execute(id: id)
    expect(found_return[:data]).to eq(expected_return[:data])
  end

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

    return_id_one = create_new_return(return_one_data)
    expect_return_with_id_to_equal(id: return_id_one, expected_return: return_one_data)

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

    return_id_two = create_new_return(return_two_data)
    expect_return_with_id_to_equal(id: return_id_two, expected_return: return_two_data)

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

    return_id_three = create_new_return(return_three_data)
    expect_return_with_id_to_equal(id: return_id_three, expected_return: return_three_data)
  end
end
