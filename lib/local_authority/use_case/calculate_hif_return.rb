# frozen_string_literal: true
require 'date'

class LocalAuthority::UseCase::CalculateHIFReturn
  def execute(return_data_with_no_calculations:, previous_return:)
    expected_return_data = {
      infrastructures: {
        planning: {
          planningNotGranted: {
            fieldOne: {
              varianceCalculations: {
                varianceAgainstLastReturn: {
                  varianceLastReturnFullPlanningPermissionSubmitted: nil
                }
              }
            }
          }
        }
      }
    }

    new_return_data = deep_merge(
      return_data_with_no_calculations,
      expected_return_data
    )
    update_varianceLastReturnFullPlanningPermissionSubmitted(
      new_return_data,
      calculate_varianceLastReturnFullPlanningPermissionSubmitted(
        return_data_with_no_calculations,
        previous_return
      )
    )
    {
      calculated_return: new_return_data
    }
  end

  private

  def calculate_varianceLastReturnFullPlanningPermissionSubmitted(
    return_data_with_no_calculations,
    previous_return
  )
    return nil if get_currentReturn(previous_return).nil?
    week_difference(
      date_as_string_one: get_currentReturn(return_data_with_no_calculations),
      date_as_string_two: get_currentReturn(previous_return)
    )
  end

  def get_currentReturn(return_data)
    return_data&.dig(:infrastructures,
      :planning,
      :planningNotGranted,
      :fieldOne,
      :returnInput,
      :currentReturn)
  end

  def update_varianceLastReturnFullPlanningPermissionSubmitted(returnData, value)
    returnData[:infrastructures][:planning][:planningNotGranted][:fieldOne][:varianceCalculations][:varianceAgainstLastReturn][:varianceLastReturnFullPlanningPermissionSubmitted] = value
  end

  def week_difference(date_as_string_one:, date_as_string_two:)
    date_one = Date.parse date_as_string_one
    date_two = Date.parse date_as_string_two

    (date_one.cweek - date_two.cweek).to_s
  end

  # based on : https://stackoverflow.com/a/30225093
  def deep_merge(first, second)
    merger = proc do |_key, v1, v2|
      if v1.class == Hash && v2.class == Hash
        v1.merge(v2, &merger)
      else
        if v1.class == Array && v2.class == Array
          v1 | v2
        else
          [:undefined, nil, :nil].include?(v2) ? v1 : v2
        end
      end
    end
    first.merge(second.to_h, &merger)
  end
end
