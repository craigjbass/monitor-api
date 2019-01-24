
class UI::UseCase::ConvertUIACReturn
  def execute(return_data:)
    @return_data = return_data
    @converted_return = {}

    convert_sites
    convert_grant_expenditure
    convert_housing_completions
    convert_s151_submission
    convert_review_and_assurance
    convert_s151_grant_claim_approval
    
    @converted_return
  end

  private

  def convert_sites
    return if @return_data[:sites].nil?
    @converted_return[:sites] = @return_data[:sites].map do |site|
      next if site.nil?
      new_site = {}
      unless site[:summary].nil?
        new_site[:summary] = site[:summary] 
      end

      unless site[:housingOutputs].nil?
        unless site[:housingOutputs][:baselineTotals].nil?
          new_site[:housingOutputs] = {
            baselineunits: site[:housingOutputs][:baselineTotals][:baselineunits],
            baselineAffordableHousingUnits: site[:housingOutputs][:baselineTotals][:baselineAffordableHousingUnits]
          }
        end
        
        unless site[:housingOutputs][:units].nil?
          new_site[:housingOutputs][:affordableHousingUnits] = site[:housingOutputs][:units][:affordableHousingUnits]
          new_site[:housingOutputs][:units] = {
            numberOfUnitsTotal: site[:housingOutputs][:units][:numberOfUnitsTotal],
            reasonForOther: site[:housingOutputs][:units][:reasonForOther]
          }
          unless site[:housingOutputs][:units][:numberOfUnits].nil?
            new_site[:housingOutputs][:units][:numberOfUnits] = site[:housingOutputs][:units][:numberOfUnits] 
          end
        end

        unless site[:housingOutputs][:paceOfConstruction].nil?
          new_site[:housingOutputs][:paceOfConstruction] = site[:housingOutputs][:paceOfConstruction]
        end

        unless site[:housingOutputs][:modernMethodsOfConstruction].nil?
          new_site[:housingOutputs][:modernMethodsOfConstruction] = site[:housingOutputs][:modernMethodsOfConstruction]
        end

        unless site[:housingOutputs][:changesRequired].nil?
          new_site[:housingOutputs][:changesRequired] = site[:housingOutputs][:changesRequired]
        end
      end

      unless site[:milestonesAndProgress].nil?
        new_site[:milestonesAndProgress] = site[:milestonesAndProgress]
      end

      new_site
    end
  end

  def convert_grant_expenditure
    return if @return_data[:grantExpenditure].nil?
    @converted_return[:grantExpenditure] = @return_data[:grantExpenditure]
  end

  def convert_housing_completions
    return if @return_data[:housingCompletions].nil?
    @converted_return[:housingCompletions] = @return_data[:housingCompletions].map do |site|
      next if site.nil?
      next if site[:details].nil?
      new_site = {
        details: {}
      }
      unless site[:details][:siteDetails].nil?
        new_site[:details][:siteName] = site[:details][:siteDetails][:siteName]
        new_site[:details][:totalLiveUnits] = site[:details][:siteDetails][:totalLiveUnits]
      end

      unless site[:details][:achievedToDate].nil?
        new_site[:details][:achievedToDate] = site[:details][:achievedToDate]
      end

      unless site[:details][:remainingEstimate].nil?
        new_site[:details][:remainingEstimate] = site[:details][:remainingEstimate]
      end
      
      new_site
    end
  end

  def convert_s151_submission
    return if @return_data[:s151submission].nil?
    @converted_return[:s151submission] = @return_data[:s151submission]
  end

  def convert_review_and_assurance
    return if @return_data[:reviewAndAssurance].nil?
    @converted_return[:reviewAndAssurance] = @return_data[:reviewAndAssurance]
  end

  def convert_s151_grant_claim_approval
    return if @return_data[:s151GrantClaimApproval].nil?
    @converted_return[:s151GrantClaimApproval] = @return_data[:s151GrantClaimApproval]
  end
end