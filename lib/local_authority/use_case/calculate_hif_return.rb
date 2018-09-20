# frozen_string_literal: true
require 'date'

class LocalAuthority::UseCase::CalculateHIFReturn
  using LocalAuthority::Refinement::HashDeepMerge
  using LocalAuthority::Refinement::DeepCopy

  def execute(return_data_with_no_calculations:, previous_return:)
    new_return_data = return_data_with_no_calculations.deep_copy

    new_return_data[:infrastructures] = [] if new_return_data[:infrastructures].nil?

    new_return_data[:infrastructures].each_with_index do |_value, i|
      new_return_data[:infrastructures][i] = new_return_data[:infrastructures][i].deep_merge(
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

      last_date = current_return(previous_return, i)
      current_date = current_return(new_return_data, i)

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
      calculated_return: new_return_data
    }
  end

  private

  def current_return(return_data, index)
    return_data&.dig(:infrastructures,
      index,
      :planning,
      :planningNotGranted,
      :fieldOne,
      :returnInput,
      :currentReturn
    )
  end

  def update_variance_last_return_full_planning_permission_submitted(return_data, infrastructure_index, value)
    return_data[:infrastructures]\
      [infrastructure_index]\
      [:planning]\
      [:planningNotGranted]\
      [:fieldOne]\
      [:varianceCalculations]\
      [:varianceAgainstLastReturn]\
      [:varianceLastReturnFullPlanningPermissionSubmitted] = value
  end

  def week_difference(date_as_string_one:, date_as_string_two:)
    return nil if date_as_string_one.nil? || date_as_string_two.nil?
    date_one = Date.parse date_as_string_one
    date_two = Date.parse date_as_string_two

    (date_one.cweek - date_two.cweek).to_s
  end
end
