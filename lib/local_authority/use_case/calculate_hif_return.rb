# frozen_string_literal: true
require 'date'

class LocalAuthority::UseCase::CalculateHIFReturn
  using LocalAuthority::Refinement::HashDeepMerge
  using LocalAuthority::Refinement::DeepCopy

  def execute(return_data_with_no_calculations:, previous_return:)
    new_return_data = return_data_with_no_calculations.deep_copy

    new_return_data[:infrastructures] = infrastructures_calculations(new_return_data, previous_return)

    new_return_data[:s151] = s151_calculations(new_return_data[:s151]) unless new_return_data[:s151].nil?
   

    {
      calculated_return: new_return_data
    }
  end

  private

  def infrastructures_calculations(return_data, previous_return)
    return [] if return_data[:infrastructures].nil?
    return_data[:infrastructures].each_with_index do |_value, i|
      return_data[:infrastructures][i] = return_data[:infrastructures][i].deep_merge(
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
      current_date = current_return(return_data, i)

      update_variance_last_return_full_planning_permission_submitted(
        return_data,
        i,
        week_difference(
          date_as_string_one: current_date,
          date_as_string_two: last_date
        )
      )
    end
    return_data[:infrastructures]
  end

  def s151_calculations(s151)
    return s151 if s151.dig(:supportingEvidence, :lastQuarterMonthSpend, :forecast).nil?
    return s151 if s151.dig(:supportingEvidence, :lastQuarterMonthSpend, :actual).nil?

    forecast = s151.dig(:supportingEvidence, :lastQuarterMonthSpend, :forecast).gsub(/[\s,]/ ,"")
    actual = s151.dig(:supportingEvidence, :lastQuarterMonthSpend, :actual).gsub(/[\s,]/ ,"")
    if (difference(forecast.to_i, actual.to_i).zero?)
      s151[:supportingEvidence][:lastQuarterMonthSpend][:hasVariance] = 'No'
    else
      s151[:supportingEvidence][:lastQuarterMonthSpend][:hasVariance] = 'Yes'
      s151[:supportingEvidence][:lastQuarterMonthSpend][:varianceAgainstForcastAmount] = difference(forecast.to_i, actual.to_i).to_s
      s151[:supportingEvidence][:lastQuarterMonthSpend][:varianceAgainstForcastPercentage] = percentage_difference(forecast.to_i, actual.to_i).to_s
    end
    s151
  end

  def percentage_difference(base, different)
    (difference(base, different) * 100)/base
  end

  def difference(base, different)
    base - different
  end

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
