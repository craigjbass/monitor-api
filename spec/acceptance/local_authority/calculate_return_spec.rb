# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Calculated return' do
  include_context 'use case factory'

  it 'creates a return with calculated fields' do
    initial_return_input_data = {
      infrastructures: {
        planning: {
          planningNotGranted: {
            fieldOne: {
              returnInput: {
                CurrentReturn: '18/08/2000'
              }
            }
          }
        }
      }
    }

    secondary_return_input_data = {
      infrastructures: {
        planning: {
          planningNotGranted: {
            fieldOne: {
              returnInput: {
                CurrentReturn: '25/08/2000'
              }
            }
          }
        }
      }
    }

    expected_return_data = {
      infrastructures: {
        planning: {
          planningNotGranted: {
            fieldOne: {
              returnInput: {
                CurrentReturn: '25/08/2000'
              },
              varianceCalculations: {
                varianceAgainstLastReturn: {
                  # Variance against Last Return submitted date (weeks)
                  varianceLastReturnFullPlanningPermissionSubmitted: '1'
                }
              }
            }
          }
        }
      }
    }

    return1_id = get_use_case(:create_return).execute(
      project_id: 1,
      data: initial_return_input_data
    )[:id]

    get_use_case(:submit_return).execute(return_id: return1_id)

    return2_id = get_use_case(:create_return).execute(
      project_id: 1,
      data: secondary_return_input_data
    )[:id]

    expected_return = {
      id: return2_id,
      project_id: 1,
      updates: [
        expected_return_data
      ],
      status: 'Draft'
    }

    expect(get_use_case(:get_return).execute(id: return2_id)).to(
      eq(expected_return)
    )
  end
end
