# frozen_string_literal: true
require 'date'

class LocalAuthority::UseCase::CalculateHIFReturn
  def execute(return_data_with_no_calculations:, previous_return:)
    #This is not at all reusable because it needs deep copying
    expected_return_data = {
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

    if return_data_with_no_calculations[:infrastructures].nil?
      return_data_with_no_calculations[:infrastructures] = []
    end

    return_data_with_no_calculations[:infrastructures].each_with_index do |value, i|
      return_data_with_no_calculations[:infrastructures][i] = deep_merge(
        return_data_with_no_calculations.dig(:infrastructures, i).to_h,
        expected_return_data
      )

      return_data_with_no_calculations[:infrastructures][i] = deep_merge(
        return_data_with_no_calculations[:infrastructures][i],
        {
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
      )

      last_date = previous_return&.dig(:infrastructures,
        i,
        :planning,
        :planningNotGranted,
        :fieldOne,
        :returnInput,
        :currentReturn)

      current_date = return_data_with_no_calculations.dig(:infrastructures,
        i,
        :planning,
        :planningNotGranted,
        :fieldOne,
        :returnInput,
        :currentReturn)


      return_data_with_no_calculations[:infrastructures][
        i][
          :planning][
            :planningNotGranted][
              :fieldOne][
                :varianceCalculations][
                  :varianceAgainstLastReturn][
                    :varianceLastReturnFullPlanningPermissionSubmitted] = week_difference(
                      date_as_string_one: current_date,
                      date_as_string_two: last_date).to_s unless last_date.nil?

    end

    {
      calculated_return: return_data_with_no_calculations
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
      0,
      :planning,
      :planningNotGranted,
      :fieldOne,
      :returnInput,
      :currentReturn)
  end

  def update_varianceLastReturnFullPlanningPermissionSubmitted(returnData, value)
    returnData[:infrastructures][0][:planning][:planningNotGranted][:fieldOne][:varianceCalculations][:varianceAgainstLastReturn][:varianceLastReturnFullPlanningPermissionSubmitted] = value
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
