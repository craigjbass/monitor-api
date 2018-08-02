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
    expect(found_return[:status]).to eq(expected_return[:status])
  end

  let(:project_baseline) do
    {
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
          submission_estimated: '2018-06-01'
        }
      },
      financial: {
        total_amount_estimated: '£ 1000000.00'
      }
    }
  end

  let(:project_base_return) do
    {
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
          submission_estimated: '2018-06-01',
          submission_actual: nil,
          submission_delay_reason: nil
        }
      },
      financial: {
        total_amount_estimated: '£ 1000000.00',
        total_amount_actual: nil,
        total_amount_changed_reason: nil
      }
    }
  end

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      type: 'hif', baseline: project_baseline
    )[:id]
  end

  before do
    project_id
  end

  it 'should keep track of Returns' do
    base_return = get_use_case(:get_base_return).execute(project_id: project_id)
    expect(base_return).to eq(base_return: project_base_return)

    return_hash = {
      project_id: project_id,
      data: {
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
            submission_estimated: '2018-06-01',
            submission_actual: '2018-07-01',
            submission_delay_reason: 'Planning office was closed for summer'
          }
        },
        financial: {
          total_amount_estimated: '£ 1000000.00',
          total_amount_actual: nil,
          total_amount_changed_reason: nil
        }
      },
      status: 'Draft'
    }

    return_id = create_new_return(return_hash)
    expect_return_with_id_to_equal(id: return_id, expected_return: return_hash)

    updated_return_hash = {
      project_id: project_id,
      data: {
        summary: {
          project_name: 'Dogs Protection League',
          description: 'A new headquarters for all the Dogs',
          lead_authority: 'Made Tech'
        },
        infrastructure: {
          type: 'Dog Bathroom',
          description: 'Bathroom for Dogs',
          completion_date: '2018-12-25',
          planning: {
            submission_estimated: '2018-06-01',
            submission_actual: '2018-07-01',
            submission_delay_reason: 'Planning office was closed for summer'
          }
        },
        financial: {
          total_amount_estimated: '£ 1000000.00',
          total_amount_actual: nil,
          total_amount_changed_reason: nil
        }
      },
      status: 'Draft'
    }
    update_return(id: return_id, data: updated_return_hash)
    expect_return_with_id_to_equal(id: return_id, expected_return: updated_return_hash)

    submitted_return_hash = {
      project_id: project_id,
      data: {
        summary: {
          project_name: 'Dogs Protection League',
          description: 'A new headquarters for all the Dogs',
          lead_authority: 'Made Tech'
        },
        infrastructure: {
          type: 'Dog Bathroom',
          description: 'Bathroom for Dogs',
          completion_date: '2018-12-25',
          planning: {
            submission_estimated: '2018-06-01',
            submission_actual: '2018-07-01',
            submission_delay_reason: 'Planning office was closed for summer'
          }
        },
        financial: {
          total_amount_estimated: '£ 1000000.00',
          total_amount_actual: nil,
          total_amount_changed_reason: nil
        }
      },
      status: 'Submitted'
    }

    submit_return(id: return_id)
    expect_return_with_id_to_equal(id: return_id, expected_return: submitted_return_hash)
  end

  def update_return(id:, data:)
    get_use_case(:update_return).execute(return_id: id, data: data)
  end

  def submit_return(id:)
    get_use_case(:submit_return).execute(return_id: id)
  end
end
