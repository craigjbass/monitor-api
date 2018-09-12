# frozen_string_literal: true
require 'date'

class LocalAuthority::UseCase::CalculateHIFReturn
  def execute(return_data_with_no_calculations:, previous_return:)
    new_return_data = return_data_with_no_calculations
    new_return_data[:infrastructures] = [] if new_return_data[:infrastructures].nil?

    new_return_data[:infrastructures].each_with_index do |_value, i|
      new_return_data[:infrastructures][i] = deep_merge(
        new_return_data[:infrastructures][i],
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

      last_date = get_currentReturn(previous_return, i)
      current_date = get_currentReturn(new_return_data, i)


      update_variance_last_return_full_planning_permission_submitted(
        new_return_data,
        i,
        week_difference(
          date_as_string_one: current_date,
          date_as_string_two: last_date
        )
      )
    end

    {
      calculated_return: return_data_with_no_calculations
    }
  end

  private

  def get_currentReturn(return_data, index)
    return_data&.dig(:infrastructures,
      index,
      :planning,
      :planningNotGranted,
      :fieldOne,
      :returnInput,
      :currentReturn)
  end

  def update_variance_last_return_full_planning_permission_submitted(return_data, infrastructure_index, value)
    return_data[:infrastructures][
      infrastructure_index][
      :planning][
      :planningNotGranted][
      :fieldOne][
      :varianceCalculations][
      :varianceAgainstLastReturn][
      :varianceLastReturnFullPlanningPermissionSubmitted] = value
  end

  def week_difference(date_as_string_one:, date_as_string_two:)
    return nil if date_as_string_one.nil? || date_as_string_two.nil?
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
