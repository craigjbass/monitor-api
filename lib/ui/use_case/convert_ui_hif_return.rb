# frozen_string_literal: true
class UI::UseCase::ConvertUIHIFReturn
  def execute(return_data:)
    @return = return_data
    @converted_return = {}

    convert_infrastructures
    convert_funding_packages
    convert_funding_profiles
    convert_outputs_forecast
    convert_outputs_actuals
    convert_s151
    convert_s151_confirmation
    convert_rm_monthly_catchup

    @converted_return
  end

  private

  def convert_infrastructures
    return if @return[:infrastructures].nil?

    @converted_return[:infrastructures] = @return[:infrastructures].map do |infrastructure|
      new_infrastructure = {}
      new_infrastructure[:summary] = infrastructure[:summary]
      new_infrastructure[:planning] = convert_planning(infrastructure[:planning]) unless infrastructure[:planning].nil?
      new_infrastructure[:landOwnership] = convert_land_ownership(infrastructure[:landOwnership]) unless infrastructure[:landOwnership].nil?
      new_infrastructure[:procurement] = convert_procurement(infrastructure[:procurement]) unless infrastructure[:procurement].nil?
      new_infrastructure[:milestones] = convert_milestones(infrastructure[:milestones]) unless infrastructure[:milestones].nil?
      new_infrastructure[:risks] = convert_risks(infrastructure[:risks]) unless infrastructure[:risks].nil?
      new_infrastructure[:progress] = convert_progress(infrastructure[:progress]) unless infrastructure[:progress].nil?
      new_infrastructure
    end
  end

  def convert_planning(planning)
    new_planning = {}

    unless planning[:outlinePlanning].nil?
      new_planning[:outlinePlanning] = {
        baselineOutlinePlanningPermissionGranted: planning[:outlinePlanning][:baselineOutlinePlanningPermissionGranted],
        baselineSummaryOfCriticalPath: planning[:outlinePlanning][:baselineSummaryOfCriticalPath],
        planningSubmitted: planning[:outlinePlanning][:planningSubmitted],
        planningGranted: planning[:outlinePlanning][:planningGranted]
      }
    end

    unless planning[:planningNotGranted].nil?
      new_planning[:planningNotGranted] = {
        fieldOne: planning[:planningNotGranted][:fieldOne]
      }
    end

    unless planning[:fullPlanning].nil?
      new_planning[:fullPlanning] = {
        fullPlanningPermissionGranted: planning[:fullPlanning][:fullPlanningPermissionGranted],
        fullPlanningPermissionSummaryOfCriticalPath: planning[:fullPlanning][:fullPlanningPermissionSummaryOfCriticalPath],
        submitted: planning[:fullPlanning][:submitted],
        granted: planning[:fullPlanning][:granted]
      }
    end

    unless planning[:section106].nil?
      new_planning[:section106] = {
        s106Requirement: planning[:section106][:s106Requirement],
        s106SummaryOfRequirement: planning[:section106][:s106SummaryOfRequirement],
        statutoryConsents: planning[:section106][:statutoryConsents]
      }
    end

    new_planning
  end

  def convert_land_ownership(land_ownership)
    new_land_ownership = {
      laHasControlOfSite: land_ownership[:laHasControlOfSite]
    }

    unless land_ownership[:laDoesNotControlSite].nil?
      new_land_ownership[:laDoesNotControlSite] = {
        whoOwnsSite: land_ownership[:laDoesNotControlSite][:whoOwnsSite],
        landAcquisitionRequired: land_ownership[:laDoesNotControlSite][:landAcquisitionRequired],
        howManySitesToAquire: land_ownership[:laDoesNotControlSite][:howManySitesToAquire],
        toBeAquiredBy: land_ownership[:laDoesNotControlSite][:toBeAquiredBy],
        summaryOfAcquisitionRequired: land_ownership[:laDoesNotControlSite][:summaryOfAcquisitionRequired],
        allLandAssemblyAchieved: land_ownership[:laDoesNotControlSite][:allLandAssemblyAchieved]
      }
    end

    new_land_ownership
  end

  def convert_procurement(procurement)
    new_procurement = {
      contractorProcured: procurement[:contractorProcured],
      nameOfContractor: procurement[:nameOfContractor],
      summaryOfCriticalPath: procurement[:summaryOfCriticalPath],
      procurementBaselineCompletion: procurement[:procurementBaselineCompletion],
      procurementVarianceAgainstLastReturn: procurement[:procurementVarianceAgainstLastReturn],
      procurementVarianceAgainstBaseline: procurement[:procurementVarianceAgainstBaseline],
      percentComplete: procurement[:percentComplete],
      procurementCompletedDate: procurement[:procurementCompletedDate],
      procurementCompletedNameOfContractor: procurement[:procurementCompletedNameOfContractor]
    }

    unless procurement[:procurementStatusAgainstLastReturn].nil?
      new_procurement[:procurementStatusAgainstLastReturn] = {
        statusAgainstLastReturn: procurement[:procurementStatusAgainstLastReturn][:statusAgainstLastReturn],
        currentReturn: procurement[:procurementStatusAgainstLastReturn][:currentReturn],
        reasonForVariance: procurement[:procurementStatusAgainstLastReturn][:reasonForVariance]
      }
    end

    new_procurement
  end

  def convert_milestones(milestones)
    new_milestones = {}

    unless milestones[:keyMilestones].nil?
      new_milestones[:keyMilestones] = milestones[:keyMilestones].map do |milestone|
        {
          description: milestone[:description],
          milestoneBaselineCompletion: milestone[:milestoneBaselineCompletion],
          milestoneSummaryOfCriticalPath: milestone[:milestoneSummaryOfCriticalPath],
          milestoneVarianceAgainstLastReturn: milestone[:milestoneVarianceAgainstLastReturn],
          milestoneVarianceAgainstBaseline: milestone[:milestoneVarianceAgainstBaseline],
          statusAgainstLastReturn: milestone[:statusAgainstLastReturn],
          currentReturn: milestone[:currentReturn],
          reasonForVariance: milestone[:reasonForVariance],
          milestonePercentCompleted: milestone[:milestonePercentCompleted],
          milestoneCompletedDate: milestone[:milestoneCompletedDate]
        }
      end
    end

    unless milestones[:additionalMilestones].nil?
      new_milestones[:additionalMilestones] = milestones[:additionalMilestones].map do |milestone|
        {
          description: milestone[:description],
          completion: milestone[:completion],
          criticalPath: milestone[:criticalPath]
        }
      end
    end

    unless milestones[:previousMilestones].nil?
      new_milestones[:previousMilestones] = milestones[:previousMilestones].map do |milestone|
        {
          description: milestone[:descrtiption],
          milestoneBaselineCompletion: milestone[:milestoneBaselineCompletion],
          milestoneSummaryOfCriticalPath: milestone[:milestoneSummaryOfCriticalPath],
          milestoneVarianceAgainstLastReturn: milestone[:milestoneVarianceAgainstLastReturn],
          milestoneVarianceAgainstBaseline: milestone[:milestoneVarianceAgainstBaseline],
          statusAgainstLastReturn: milestone[:statusAgainstLastReturn],
          currentReturn: milestone[:currentReturn],
          reasonForVariance: milestone[:reasonForVariance],
          milestonePercentCompleted: milestone[:milestonePercentCompleted],
          milestoneCompletedDate: milestone[:milestoneCompletedDate]
        }
      end
    end

    new_milestones[:expectedInfrastructureStartOnSite] = milestones[:expectedInfrastructureStartOnSite]
    new_milestones[:expectedCompletionDateOfInfra] = milestones[:expectedCompletionDateOfInfra]

    new_milestones
  end

  def convert_risks(risks)
    new_risks = {}

    unless risks[:baselineRisks].nil?
      new_risks[:baselineRisks] = risks[:baselineRisks].map do |risk|
        new_risk = {}
        new_risk[:riskBaselineRisk] = risk[:riskBaselineRisk]
        new_risk[:riskBaselineImpact] = risk[:riskBaselineImpact]
        new_risk[:riskBaselineLikelihood] = risk[:riskBaselineLikelihood]
        new_risk[:riskBaselineMitigationsInPlace] = risk[:riskBaselineMitigationsInPlace]
        new_risk[:riskAnyChange] = risk[:riskAnyChange]
        new_risk[:riskCurrentReturnMitigationsInPlace] = risk[:riskCurrentReturnMitigationsInPlace]
        new_risk[:riskMetDate] = risk[:riskMetDate]
        new_risk
      end
    end

    unless risks[:additionalRisks].nil?
      new_risks[:additionalRisks] = risks[:additionalRisks].map do |risk|
        {
          description: risk[:description],
          impact: risk[:impact],
          likelihood: risk[:likelihood],
          mitigations: risk[:mitigations]
        }
      end
    end

    unless risks[:previousRisks].nil?
      new_risks[:previousRisks] = risks[:previousRisks].map do |risk|
        {
          riskBaselineRisk: risk[:riskBaselineRisk],
          riskBaselineImpact: risk[:riskBaselineImpact],
          riskBaselineLikelihood: risk[:riskBaselineLikelihood],
          riskCurrentReturnLikelihood: risk[:riskCurrentReturnLikelihood],
          riskBaselineMitigationsInPlace: risk[:riskBaselineMitigationsInPlace],
          riskAnyChange: risk[:riskAnyChange],
          riskCurrentReturnMitigationsInPlace: risk[:riskCurrentReturnMitigationsInPlace],
          riskMetDate: risk[:riskMetDate]
        }
      end
    end

    new_risks
  end

  def convert_progress(progress)
    new_progress = {
      describeQuarterProgress: progress[:describeQuarterProgress]
    }

    unless progress[:progressAgainstActions].nil?
      new_progress[:progressAgainstActions] = progress[:progressAgainstActions].map do |action|
        {
          description: action[:description],
          met: action[:met],
          progress: action[:progress]
        }
      end
    end

    unless progress[:actionsForNextQuarter].nil?
      new_progress[:actionsForNextQuarter] = progress[:actionsForNextQuarter].map do |action|
        {
          description: action[:description]
        }
      end
    end

    new_progress
  end

  def convert_funding_profiles
    return if @return[:fundingProfiles].nil?
    @converted_return[:fundingProfiles] = {}
    @converted_return[:fundingProfiles][:totalHIFGrant] = @return[:fundingProfiles][:totalHIFGrant]

    @converted_return[:fundingProfiles][:fundingRequest] = @return[:fundingProfiles][:fundingRequest].map do |request|
      next if request.nil?

      new_request = { period: request[:period] }

      next new_request if request[:forecast].nil?
      new_request[:forecast] = {
        instalment1: request[:forecast][:instalment1],
        instalment2: request[:forecast][:instalment2],
        instalment3: request[:forecast][:instalment3],
        instalment4: request[:forecast][:instalment4],
        total: request[:forecast][:total]
      }
      new_request
    end
    @converted_return[:fundingProfiles][:changeRequired] = @return[:fundingProfiles][:changeRequired]
    @converted_return[:fundingProfiles][:reasonForRequest] = @return[:fundingProfiles][:reasonForRequest]
    @converted_return[:fundingProfiles][:mitigationInPlace] = @return[:fundingProfiles][:mitigationInPlace]

    @converted_return[:fundingProfiles][:requestedProfiles] = @return[:fundingProfiles][:requestedProfiles].map do |request|
      next if request.nil?

      new_request = { period: request[:period] }

      next new_request if request[:newProfile].nil?
      new_request[:newProfile] = {
        instalment1: request[:newProfile][:instalment1],
        instalment2: request[:newProfile][:instalment2],
        instalment3: request[:newProfile][:instalment3],
        instalment4: request[:newProfile][:instalment4],
        total: request[:newProfile][:total]
      }
      new_request
    end
  end

  def convert_funding_packages
    return if @return[:fundingPackages].nil?
    @converted_return[:fundingPackages] = @return[:fundingPackages].map do |package|
      new_package = {}
      next if package[:fundingStack].nil?
      new_package[:fundingStack] = {}
      unless package[:fundingStack][:hifSpend].nil?
        new_package[:fundingStack][:hifSpend] = {
          baseline: package[:fundingStack][:hifSpend][:baseline],
          current: package[:fundingStack][:hifSpend][:current],
          lastReturn: package[:fundingStack][:hifSpend][:lastReturn]
        }
      end

      unless package[:fundingStack][:totalCost].nil?
        new_package[:fundingStack][:totalCost] = {
          baseline: package[:fundingStack][:totalCost][:baseline],
          current: package[:fundingStack][:totalCost][:current],
          varianceReason: package[:fundingStack][:totalCost][:varianceReason],
          percentComplete: package[:fundingStack][:totalCost][:percentComplete]
        }
      end

      new_package[:fundingStack][:fundedThroughHIF] = package[:fundingStack][:fundedThroughHIF]
      new_package[:fundingStack][:descriptionOfFundingStack] = package[:fundingStack][:descriptionOfFundingStack]

      unless package[:fundingStack][:riskToFundingPackage].nil?
        new_package[:fundingStack][:riskToFundingPackage] = {
          risk: package[:fundingStack][:riskToFundingPackage][:risk],
          description: package[:fundingStack][:riskToFundingPackage][:description]
        }
      end

      unless package[:fundingStack][:public].nil?
        new_package[:fundingStack][:public] = {
          baseline: package[:fundingStack][:public][:baseline],
          current: package[:fundingStack][:public][:current],
          reason: package[:fundingStack][:public][:reason],
          amountSecured: package[:fundingStack][:public][:amountSecured]
        }
      end

      unless package[:fundingStack][:private].nil?
        new_package[:fundingStack][:private] = {
          baseline: package[:fundingStack][:private][:baseline],
          current: package[:fundingStack][:private][:current],
          reason: package[:fundingStack][:private][:reason],
          amountSecured: package[:fundingStack][:private][:amountSecured]
        }
      end

      new_package
    end
  end

  def convert_outputs_forecast
    return if @return[:outputsForecast].nil?
    @converted_return[:outputsForecast] = {}

    unless @return[:outputsForecast][:summary].nil?
      @converted_return[:outputsForecast][:summary] = {
        totalUnits: @return[:outputsForecast][:summary][:totalUnits],
        disposalStrategy:@return[:outputsForecast][:summary][:disposalStrategy]
      }
    end

    unless @return[:outputsForecast][:housingStarts].nil?
      @converted_return[:outputsForecast][:housingStarts] = {}

      @converted_return[:outputsForecast][:housingStarts][:baselineAmounts] = @return[:outputsForecast][:housingStarts][:baselineAmounts].map do |amount|
        {
          period: amount[:period],
          baselineAmounts: amount[:baselineAmounts]
        }
      end

      @converted_return[:outputsForecast][:housingStarts][:anyChanges] = @return[:outputsForecast][:housingStarts][:anyChanges]
      @converted_return[:outputsForecast][:housingStarts][:currentReturnAmounts] = @return[:outputsForecast][:housingStarts][:currentReturnAmounts] do |amount|
        {
          period: amount[:period],
          currentReturnForecast: amount[:currentReturnForecast]
        }
      end
    end

    unless @return[:outputsForecast][:inYearHousingStarts].nil?
      @converted_return[:outputsForecast][:inYearHousingStarts] = {
        risksToAchieving: @return[:outputsForecast][:inYearHousingStarts][:risksToAchieving]
      }
    end

    unless @return[:outputsForecast][:housingCompletions].nil?
      @converted_return[:outputsForecast][:housingCompletions] = {}

      @converted_return[:outputsForecast][:housingCompletions][:baselineAmounts] = @return[:outputsForecast][:housingCompletions][:baselineAmounts].map do |amount|
        {
          period: amount[:period],
          baselineAmounts: amount[:baselineAmounts]
        }
      end

      @converted_return[:outputsForecast][:housingCompletions][:anyChanges] = @return[:outputsForecast][:housingCompletions][:anyChanges]
      @converted_return[:outputsForecast][:housingCompletions][:currentReturnAmounts] = @return[:outputsForecast][:housingCompletions][:currentReturnAmounts] do |amount|
        {
          period: amount[:period],
          currentReturnForecast: amount[:currentReturnForecast]
        }
      end


    end

    unless @return[:outputsForecast][:inYearHousingCompletions].nil?
      @converted_return[:outputsForecast][:inYearHousingCompletions] = {
        risksToAchieving: @return[:outputsForecast][:inYearHousingCompletions][:risksToAchieving]
      }
    end
  end

  def convert_s151_confirmation
    return if @return[:s151Confirmation].nil?
    @converted_return[:s151Confirmation] = {}

    unless @return[:s151Confirmation][:hifFunding].nil?
      @converted_return[:s151Confirmation][:hifFunding] = {
        hifTotalFundingRequest: @return[:s151Confirmation][:hifFunding][:hifTotalFundingRequest],
        changesToRequest: @return[:s151Confirmation][:hifFunding][:changesToRequest][:changesToRequestConfirmation]
      }

      @converted_return[:s151Confirmation][:hifFunding][:hifFundingProfile] = @return[:s151Confirmation][:hifFunding][:hifFundingProfile].map do |profile|
        {
          period: profile[:period],
          instalment1: profile[:instalment1],
          instalment2: profile[:instalment2],
          instalment3: profile[:instalment3],
          instalment4: profile[:instalment4],
          total: profile[:total],
          baselineVariance1: profile[:baselineVariance1],
          baselineVariance2: profile[:baselineVariance2],
          baselineVariance3: profile[:baselineVariance3],
          baselineVariance4: profile[:baselineVariance4],
          lastMovement1: profile[:lastMovement1],
          lastMovement2: profile[:lastMovement2],
          lastMovement3: profile[:lastMovement3],
          lastMovement4: profile[:lastMovement4],
          movementVariance1: profile[:movementVariance1],
          movementVariance2: profile[:movementVariance2],
          movementVariance3: profile[:movementVariance3],
          movementVariance4: profile[:movementVariance4]
        }
      end

      @converted_return[:s151Confirmation][:hifFunding][:amendmentConfirmation] = @return[:s151Confirmation][:hifFunding][:amendmentConfirmation]
      @converted_return[:s151Confirmation][:hifFunding][:cashflowConfirmation] = @return[:s151Confirmation][:hifFunding][:cashflowConfirmation]
      @converted_return[:s151Confirmation][:hifFunding][:reasonForRequest] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:reasonForRequest]
      @converted_return[:s151Confirmation][:hifFunding][:requestedAmount] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:requestedAmount]
      @converted_return[:s151Confirmation][:hifFunding][:varianceFromBaseline] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:varianceFromBaseline]
      @converted_return[:s151Confirmation][:hifFunding][:varianceFromBaselinePercent] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:varianceFromBaselinePercent]
      @converted_return[:s151Confirmation][:hifFunding][:mitigationInPlace] = @return[:s151Confirmation][:hifFunding][:changesToRequest][:mitigationInPlace]
    end

    return if @return[:s151Confirmation][:submission].nil?
    @converted_return[:s151Confirmation][:submission] = {
      changeToMilestones: @return[:s151Confirmation][:submission][:changeToMilestones][:changeToMilestonesConfirmation],
      requestedAmendments: @return[:s151Confirmation][:submission][:changeToMilestones][:requestedAmendments],
      reasonForRequestOfMilestoneChange: @return[:s151Confirmation][:submission][:changeToMilestones][:reasonForRequestOfMilestoneChange],
      mitigationInPlaceMilestone: @return[:s151Confirmation][:submission][:changeToMilestones][:mitigationInPlaceMilestone],

      changesToEndDate: @return[:s151Confirmation][:submission][:changesToEndDate][:changesToEndDateConfirmation],
      reasonForRequestOfDateChange: @return[:s151Confirmation][:submission][:changesToEndDate][:reasonForRequestOfDateChange],
      requestedChangedEndDate: @return[:s151Confirmation][:submission][:changesToEndDate][:requestedChangedEndDate],
      mitigationInPlaceEndDate: @return[:s151Confirmation][:submission][:changesToEndDate][:mitigationInPlaceEndDate],
      varianceFromEndDateBaseline: @return[:s151Confirmation][:submission][:changesToEndDate][:varianceFromEndDateBaseline],


      changesToLongstopDate: @return[:s151Confirmation][:submission][:changesToLongstopDate][:changesToLongstopDateConfirmation],
      reasonForRequestOfLongstopChange: @return[:s151Confirmation][:submission][:changesToLongstopDate][:reasonForRequestOfLongstopChange],
      requestedLongstopEndDate: @return[:s151Confirmation][:submission][:changesToLongstopDate][:requestedLongstopEndDate],
      varianceFromLongStopBaseline: @return[:s151Confirmation][:submission][:changesToLongstopDate][:varianceFromLongStopBaseline],
      mitigationInPlaceLongstopDate: @return[:s151Confirmation][:submission][:changesToLongstopDate][:mitigationInPlaceLongstopDate],

      recoverFunding: @return[:s151Confirmation][:submission][:recoverFunding][:recoverFundingConfirmation],
      usedOnFutureHosuing: @return[:s151Confirmation][:submission][:recoverFunding][:usedOnFutureHousing],

      hifFundingEndDate: @return[:s151Confirmation][:submission][:hifFundingEndDate],
      projectLongstopDate: @return[:s151Confirmation][:submission][:projectLongstopDate]
    }
  end

  def convert_s151
    return if @return[:s151].nil?
    @converted_return[:s151] = {}

    unless @return[:s151][:claimSummary].nil?
      @converted_return[:s151][:claimSummary] = {
        hifTotalFundingRequest: @return[:s151][:claimSummary][:hifTotalFundingRequest],
        hifSpendToDate: @return[:s151][:claimSummary][:hifSpendToDate],
        AmountOfThisClaim: @return[:s151][:claimSummary][:AmountOfThisClaim]
      }
    end

    return if @return[:s151][:supportingEvidence].nil?
    @converted_return[:s151][:supportingEvidence] = {}
    unless @return[:s151][:supportingEvidence][:lastQuarterMonthSpend].nil?
      @converted_return[:s151][:supportingEvidence][:lastQuarterMonthSpend] = {
        forecast: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:forecast],
        actual: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:actual],
        hasVariance: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:hasVariance],
        varianceAgainstForcastAmount: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:varianceAgainstForcastAmount],
        varianceAgainstForcastPercentage: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:varianceAgainstForcastPercentage]
      }
    end

    @converted_return[:s151][:supportingEvidence][:evidenceOfSpendPastQuarter] = @return[:s151][:supportingEvidence][:evidenceOfSpendPastQuarter]

    return if @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend].nil?

    @converted_return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend] = {
      forecast: @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend][:forecast],
      descriptionOfSpend: @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend][:descriptionOfSpend],
      evidenceOfSpendNextQuarter: @return[:s151][:supportingEvidence][:breakdownOfNextQuarterSpend][:evidenceOfSpendNextQuarter]
    }
  end

  def convert_rm_monthly_catchup
    return if @return[:rmMonthlyCatchup].nil?
    @converted_return[:rmMonthlyCatchup] = {}

    @converted_return[:rmMonthlyCatchup][:dateOfCatchUp] = @return[:rmMonthlyCatchup][:dateOfCatchUp]
    @converted_return[:rmMonthlyCatchup][:overallRatingForScheme] = @return[:rmMonthlyCatchup][:overallRatingForScheme]

    @converted_return[:rmMonthlyCatchup][:redBarriers] = @return[:rmMonthlyCatchup][:redBarriers].map do |barrier|
      {
        overview: barrier[:overview]
      }
    end

    @converted_return[:rmMonthlyCatchup][:amberBarriers] = @return[:rmMonthlyCatchup][:amberBarriers].map do |barrier|
      {
        overview: barrier[:overview]
      }
    end

    @converted_return[:rmMonthlyCatchup][:overviewOfEngagement] = @return[:rmMonthlyCatchup][:overviewOfEngagement]
    @converted_return[:rmMonthlyCatchup][:commentOnProgress] = @return[:rmMonthlyCatchup][:commentOnProgress]
    @converted_return[:rmMonthlyCatchup][:issuesToRaise] = @return[:rmMonthlyCatchup][:issuesToRaise]

  end

  def convert_outputs_actuals
    return if @return[:outputsActuals].nil?
    @converted_return[:outputsActuals] = {}

    @converted_return[:outputsActuals][:localAuthority] = @return[:outputsActuals][:localAuthority]
    @converted_return[:outputsActuals][:noOfUnits] = @return[:outputsActuals][:noOfUnits]
    @converted_return[:outputsActuals][:size] = @return[:outputsActuals][:size]
    @converted_return[:outputsActuals][:previousStarts] = @return[:outputsActuals][:previousStarts]
    @converted_return[:outputsActuals][:startsSinceLastReturn] = @return[:outputsActuals][:startsSinceLastReturn]
    @converted_return[:outputsActuals][:previousCompletions] = @return[:outputsActuals][:previousCompletions]
    @converted_return[:outputsActuals][:completionsSinceLastReturn] = @return[:outputsActuals][:completionsSinceLastReturn]
    @converted_return[:outputsActuals][:laOwned] = @return[:outputsActuals][:laOwned]
    @converted_return[:outputsActuals][:pslLand] = @return[:outputsActuals][:pslLand]
    @converted_return[:outputsActuals][:brownfieldPercent] = @return[:outputsActuals][:brownfieldPercent]
    @converted_return[:outputsActuals][:leaseholdPercent] = @return[:outputsActuals][:leaseholdPercent]
    @converted_return[:outputsActuals][:smePercent] = @return[:outputsActuals][:smePercent]
    @converted_return[:outputsActuals][:mmcPercent] = @return[:outputsActuals][:mmcPercent]
  end
end
