
class UI::UseCase::ConvertCoreACReturn
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
    @converted_return[:sites] = @return_data[:sites]
  end

  def convert_grant_expenditure
    return if @return_data[:grantExpenditure].nil?
    @converted_return[:grantExpenditure] = @return_data[:grantExpenditure]
  end

  def convert_housing_completions
    return if @return_data[:housingCompletions].nil?
    @converted_return[:housingCompletions] = @return_data[:housingCompletions]
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