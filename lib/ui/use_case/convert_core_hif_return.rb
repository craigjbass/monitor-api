# frozen_string_literal: true
class UI::UseCase::ConvertCoreHIFReturn
  def execute(return_data:)
    @return = return_data
    @converted_return = {}

    convert_infrastructures
    convert_funding_packages
    convert_funding_profiles
    convert_wider_scheme
    convert_outputs_forecast
    convert_outputs_actuals
    convert_s151
    convert_s151_confirmation
    convert_rm_monthly_catchup
    convert_mr_review_tab

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
        planningGranted: planning[:outlinePlanning][:planningGranted],
        reference: planning[:outlinePlanning][:reference]

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
        granted: planning[:fullPlanning][:granted],
        reference: planning[:fullPlanning][:reference]
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
    }
    new_procurement[:procurementStatusAgainstLastReturn] = {}

    unless procurement[:procurementStatusAgainstLastReturn].nil?
      new_procurement[:procurementStatusAgainstLastReturn] = {
        status: procurement[:procurementStatusAgainstLastReturn][:statusAgainstLastReturn],
        current: procurement[:procurementStatusAgainstLastReturn][:currentReturn],
        reason: procurement[:procurementStatusAgainstLastReturn][:reasonForVariance],
        previousReturn: procurement[:procurementStatusAgainstLastReturn][:previousReturn]
      }
    end

    new_procurement[:procurementStatusAgainstLastReturn][:baseline] = procurement[:procurementBaselineCompletion]
    new_procurement[:procurementStatusAgainstLastReturn][:procurementVarianceAgainstLastReturn] = procurement[:procurementVarianceAgainstLastReturn]
    new_procurement[:procurementStatusAgainstLastReturn][:procurementVarianceAgainstBaseline] = procurement[:procurementVarianceAgainstBaseline]
    new_procurement[:procurementStatusAgainstLastReturn][:percentComplete] = procurement[:percentComplete]
    new_procurement[:procurementStatusAgainstLastReturn][:completedDate] = procurement[:procurementCompletedDate]
    new_procurement[:procurementStatusAgainstLastReturn][:onCompletedNameOfContractor] = procurement[:procurementCompletedNameOfContractor]

    new_procurement
  end

  def convert_milestones(milestones)
    new_milestones = {}

    unless milestones[:keyMilestones].nil?
      new_milestones[:keyMilestones] = milestones[:keyMilestones].map do |milestone|
        {
          description: milestone[:description],
          milestoneBaselineCompletion: milestone[:milestoneBaselineCompletion],
          milestoneLastReturnDate: milestone[:milestoneLastReturnDate],
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

    unless milestones[:cumulativeadditionalMilestones].nil?
      new_milestones[:cumulativeadditionalMilestones] = milestones[:cumulativeadditionalMilestones].map do |milestone|
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
          description: milestone[:description],
          completion: milestone[:milestoneBaselineCompletion],
          criticalPath: milestone[:milestoneSummaryOfCriticalPath],
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
        new_risk[:riskCurrentReturnLikelihood] = risk[:riskCurrentReturnLikelihood]
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

    unless risks[:cumulativeadditionalRisks].nil?
      new_risks[:cumulativeadditionalRisks] = risks[:cumulativeadditionalRisks].map do |risk|
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
          description: risk[:riskBaselineRisk],
          impact: risk[:riskBaselineImpact],
          likelihood: risk[:riskBaselineLikelihood],
          riskCurrentReturnLikelihood: risk[:riskCurrentReturnLikelihood],
          mitigations: risk[:riskBaselineMitigationsInPlace],
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

    @converted_return[:fundingProfiles][:fundingRequest] = {}

    @converted_return[:fundingProfiles][:fundingRequest][:forecast] = @return[:fundingProfiles][:fundingRequest].map do |request|
      next if request.nil?
      new_request = { period: request[:period] }

      next new_request if request[:forecast].nil?

      new_request[:instalment1] = request[:forecast][:instalment1]
      new_request[:instalment2] = request[:forecast][:instalment2]
      new_request[:instalment3] = request[:forecast][:instalment3]
      new_request[:instalment4] = request[:forecast][:instalment4]
      new_request[:total] = request[:forecast][:total]

      new_request
    end

    @converted_return[:fundingProfiles][:currentFunding] = {}

    unless @return[:fundingProfiles][:currentFunding].nil?
      @converted_return[:fundingProfiles][:currentFunding][:forecast] = @return[:fundingProfiles][:currentFunding][:forecast].map do |request|
        next if request.nil?
        {
          period: request[:period],
          instalment1: request[:instalment1],
          instalment2: request[:instalment2],
          instalment3: request[:instalment3],
          instalment4: request[:instalment4],
          total: request[:total]
        }
      end
    end


    @converted_return[:fundingProfiles][:changeRequired] = @return[:fundingProfiles][:changeRequired]
    @converted_return[:fundingProfiles][:reasonForRequest] = @return[:fundingProfiles][:reasonForRequest]
    @converted_return[:fundingProfiles][:mitigationInPlace] = @return[:fundingProfiles][:mitigationInPlace]

    @converted_return[:fundingProfiles][:requestedProfiles] = {}

    @converted_return[:fundingProfiles][:requestedProfiles][:newProfile] = @return[:fundingProfiles][:requestedProfiles].map do |request|
      next if request.nil?

      new_request = { period: request[:period] }

      next new_request if request[:newProfile].nil?

      new_request[:instalment1] = request[:newProfile][:instalment1]
      new_request[:instalment2] = request[:newProfile][:instalment2]
      new_request[:instalment3] = request[:newProfile][:instalment3]
      new_request[:instalment4] = request[:newProfile][:instalment4]

      new_request[:totalHolder] = {}
      new_request[:totalHolder][:total] = request[:newProfile][:total]

      new_request
    end

    @converted_return[:fundingProfiles][:projectCashflows] = @return[:fundingProfiles][:projectCashflows]

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

  def convert_wider_scheme
    @converted_return[:widerScheme] = [{keyLiveIssues: [{}]}]
    return if @return[:widerScheme].nil?

    unless @return[:widerScheme][0][:overview].nil?
      @converted_return[:widerScheme][0][:overview] = {
        developmentPlan: @return[:widerScheme][0][:overview][:developmentPlan]
      }

      unless @return[:widerScheme][0][:overview][:masterplan].nil?
        @converted_return[:widerScheme][0][:overview][:masterplan] = {
          confirmation: @return[:widerScheme][0][:overview][:masterplan][:confirmation],
          planAttachment: @return[:widerScheme][0][:overview][:masterplan][:planAttachment]
        }
      end
    end

    @converted_return[:widerScheme][0][:keyLiveIssues] = @return[:widerScheme][0][:keyLiveIssues].map do |issue|
      next if issue.nil?
      new_issue = {
        description: issue[:description],
      }

      unless issue[:dates].nil?
        new_issue[:dates] = {
          dateRaised: issue[:dates][:dateRaised],
          estimatedCompletionDate: issue[:dates][:estimatedCompletionDate]
        }
      end

      unless issue[:currentdetails].nil?
        new_issue[:currentdetails] = {
          impact: issue[:currentdetails][:impact],
          currentStatus: issue[:currentdetails][:currentStatus],
          currentReturnLikelihood: issue[:currentdetails][:currentReturnLikelihood]
        }
      end

      new_issue[:mitigationActions] = issue[:mitigationActions]
      new_issue[:ratingAfterMitigation] = issue[:ratingAfterMitigation]

      new_issue
    end

    unless @return[:widerScheme][0][:topRisks].nil?
      @converted_return[:widerScheme][0][:topRisks] = {}

      @converted_return[:widerScheme][0][:topRisks][:landAssembly] = convert_top_risk(@return[:widerScheme][0][:topRisks][:landAssembly])
      @converted_return[:widerScheme][0][:topRisks][:procurementInfrastructure] = convert_top_risk(@return[:widerScheme][0][:topRisks][:procurementInfrastructure])
      @converted_return[:widerScheme][0][:topRisks][:planningInfrastructure] = convert_top_risk(@return[:widerScheme][0][:topRisks][:planningInfrastructure])
      @converted_return[:widerScheme][0][:topRisks][:deliveryInfrastructure] = convert_top_risk(@return[:widerScheme][0][:topRisks][:deliveryInfrastructure])
      @converted_return[:widerScheme][0][:topRisks][:procurementHousing] = convert_top_risk(@return[:widerScheme][0][:topRisks][:procurementHousing])
      @converted_return[:widerScheme][0][:topRisks][:planningHousing] = convert_top_risk(@return[:widerScheme][0][:topRisks][:planningHousing])
      @converted_return[:widerScheme][0][:topRisks][:delivery] = convert_top_risk(@return[:widerScheme][0][:topRisks][:delivery])
      @converted_return[:widerScheme][0][:topRisks][:fundingPackage] = convert_top_risk(@return[:widerScheme][0][:topRisks][:fundingPackage])

      unless @return[:widerScheme][0][:topRisks][:additionalRisks].nil?
        @converted_return[:widerScheme][0][:topRisks][:additionalRisks] = @return[:widerScheme][0][:topRisks][:additionalRisks].map do |risk|
          convert_top_risk(risk)
        end
      end

      @converted_return[:widerScheme][0][:topRisks][:progressLastQuarter] = @return[:widerScheme][0][:topRisks][:progressLastQuarter]
      @converted_return[:widerScheme][0][:topRisks][:actionsLastQuarter] = @return[:widerScheme][0][:topRisks][:actionsLastQuarter]
      @converted_return[:widerScheme][0][:topRisks][:riskRegister] = @return[:widerScheme][0][:topRisks][:riskRegister]
    end
  end

  def convert_top_risk(risk)
    return if risk.nil?
    new_risk = {
      liveRisk: risk[:liveRisk],
      description: risk[:description],
      varianceAmount: risk[:varianceAmount],
      varianceReason: risk[:varianceReason],
      baselineMitigationMeasures: risk[:baselineMitigationMeasures],
      riskAfterMitigation: risk[:riskAfterMitigation]
    }

    unless risk[:dates].nil?
      new_risk[:dates] = {
        expectedCompletion: risk[:dates][:expectedCompletion],
        currentReturnCompletionDate: risk[:dates][:currentReturnCompletionDate]
      }
    end

    unless risk[:ratings].nil?
      new_risk[:ratings] = {
        baselineImpact: risk[:ratings][:baselineImpact],
        baselineLikelihood: risk[:ratings][:baselineLikelihood],
        currentReturnLikelihood: risk[:ratings][:currentReturnLikelihood]
      }
    end

    unless risk[:anyChange].nil?
      new_risk[:anyChange] = {
        confirmation: risk[:anyChange][:confirmation],
        updatedMeasures: risk[:anyChange][:updatedMeasures]
      }
    end

    unless risk[:riskMet].nil?
      new_risk[:riskMet] = {
        confirmation: risk[:riskMet][:confirmation],
        dateMet: risk[:riskMet][:dateMet]
      }
    end

    new_risk
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
        baselineAmounts: @return[:outputsForecast][:inYearHousingStarts][:baselineAmounts],
        actualAmounts: @return[:outputsForecast][:inYearHousingStarts][:actualAmounts],
        progress: @return[:outputsForecast][:inYearHousingStarts][:progress]
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
        baselineAmounts: @return[:outputsForecast][:inYearHousingCompletions][:baselineAmounts],
        actualAmounts: @return[:outputsForecast][:inYearHousingCompletions][:actualAmounts],
        progress: @return[:outputsForecast][:inYearHousingCompletions][:progress]
      }
    end
  end

  def convert_s151_confirmation
    return if @return[:s151Confirmation].nil?
    @converted_return[:s151Confirmation] = {}

    unless @return[:s151Confirmation][:hifFunding].nil?
      @converted_return[:s151Confirmation][:hifFunding] = {
        hifTotalFundingRequest: @return[:s151Confirmation][:hifFunding][:hifTotalFundingRequest]
      }

      @converted_return[:s151Confirmation][:hifFunding][:changesToRequest] = {
        changesToRequestConfirmation: @return[:s151Confirmation][:hifFunding][:changesToRequest],
        requestedAmount: @return[:s151Confirmation][:hifFunding][:requestedAmount],
        reasonForRequest: @return[:s151Confirmation][:hifFunding][:reasonForRequest],
        evidenceOfVariance: @return[:s151Confirmation][:hifFunding][:evidenceOfVariance],
        mitigationInPlace: @return[:s151Confirmation][:hifFunding][:mitigationInPlace]
      }

      @converted_return[:s151Confirmation][:hifFunding][:changesToRequest][:varianceFromBaseline] = {
        varianceFromBaselinePercent: @return[:s151Confirmation][:hifFunding][:varianceFromBaselinePercent],
        variance: @return[:s151Confirmation][:hifFunding][:varianceFromBaseline]
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
    end

    return if @return[:s151Confirmation][:submission].nil?

    @converted_return[:s151Confirmation][:submission] = {
      hifFundingEndDate: @return[:s151Confirmation][:submission][:hifFundingEndDate],
      projectLongstopDate: @return[:s151Confirmation][:submission][:projectLongstopDate],
      signoff: @return[:s151Confirmation][:submission][:signoff]
    }

    @converted_return[:s151Confirmation][:submission][:recoverFunding] = {
      recoverFundingConfirmation: @return[:s151Confirmation][:submission][:recoverFunding],
      usedOnFutureHousing: @return[:s151Confirmation][:submission][:usedOnFutureHosuing]
    }

    @converted_return[:s151Confirmation][:submission][:changesToLongstopDate] = {
      changesToLongstopDateConfirmation: @return[:s151Confirmation][:submission][:changesToLongstopDate],
      reasonForRequestOfLongstopChange: @return[:s151Confirmation][:submission][:reasonForRequestOfLongstopChange],
      requestedLongstopEndDate: @return[:s151Confirmation][:submission][:requestedLongstopEndDate],
      varianceFromLongStopBaseline: @return[:s151Confirmation][:submission][:varianceFromLongStopBaseline],
      mitigationInPlaceLongstopDate: @return[:s151Confirmation][:submission][:mitigationInPlaceLongstopDate],
    }

    @converted_return[:s151Confirmation][:submission][:changeToMilestones] = {
      requestedAmendments: @return[:s151Confirmation][:submission][:requestedAmendments],
      changeToMilestonesConfirmation: @return[:s151Confirmation][:submission][:changeToMilestones],
      reasonForRequestOfMilestoneChange: @return[:s151Confirmation][:submission][:reasonForRequestOfMilestoneChange],
      mitigationInPlaceMilestone: @return[:s151Confirmation][:submission][:mitigationInPlaceMilestone]
    }

    @converted_return[:s151Confirmation][:submission][:changesToEndDate] = {
      changesToEndDateConfirmation: @return[:s151Confirmation][:submission][:changesToEndDate],
      reasonForRequestOfDateChange: @return[:s151Confirmation][:submission][:reasonForRequestOfDateChange],
      requestedChangedEndDate: @return[:s151Confirmation][:submission][:requestedChangedEndDate],
      mitigationInPlaceEndDate: @return[:s151Confirmation][:submission][:mitigationInPlaceEndDate],
      varianceFromEndDateBaseline: @return[:s151Confirmation][:submission][:varianceFromEndDateBaseline]
    }
  end

  def convert_s151
    return if @return[:s151].nil?
    @converted_return[:s151] = {}

    unless @return[:s151][:claimSummary].nil?
      @converted_return[:s151][:claimSummary] = {
        hifTotalFundingRequest: @return[:s151][:claimSummary][:hifTotalFundingRequest],
        hifSpendToDate: @return[:s151][:claimSummary][:hifSpendToDate],
        AmountOfThisClaim: @return[:s151][:claimSummary][:AmountOfThisClaim],
        certifiedClaimForm: @return[:s151][:claimSummary][:certifiedClaimForm],
        runningClaimTotal: @return[:s151][:claimSummary][:runningClaimTotal]
      }
    end

    return if @return[:s151][:supportingEvidence].nil?
    @converted_return[:s151][:supportingEvidence] = {}
    unless @return[:s151][:supportingEvidence][:lastQuarterMonthSpend].nil?
      @converted_return[:s151][:supportingEvidence][:lastQuarterMonthSpend] = {
        forecast: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:forecast],
        actual: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:actual],
        varianceReason: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:varianceReason]
      }
      unless @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance].nil?
        @converted_return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance] = {
          varianceAgainstForcastAmount: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance][:varianceAgainstForcastAmount],
          varianceAgainstForcastPercentage: @return[:s151][:supportingEvidence][:lastQuarterMonthSpend][:variance][:varianceAgainstForcastPercentage]
        }
      end
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
    @converted_return[:rmMonthlyCatchup] = {
      catchUp: [{}]
    }
    return if @return[:rmMonthlyCatchup].nil?

    unless @return[:rmMonthlyCatchup][:catchUp].nil?
      @converted_return[:rmMonthlyCatchup][:catchUp] = @return[:rmMonthlyCatchup][:catchUp].map do |catch_up|
        next if catch_up.nil?
        new_catch_up = {}
        new_catch_up[:dateOfCatchUp] = catch_up[:dateOfCatchUp]
        new_catch_up[:overallRatingForScheme] = catch_up[:overallRatingForScheme]
        unless catch_up[:redBarriers].nil?
          new_catch_up[:redBarriers] = catch_up[:redBarriers].map do |red_barrier|
            next if red_barrier.nil?
            {
              barrier: red_barrier[:barrier],
              overview: red_barrier[:overview],
              description: red_barrier[:description]
            }
          end
        end

        unless catch_up[:amberBarriers].nil?
          new_catch_up[:amberBarriers] = catch_up[:amberBarriers].map do |amber_barrier|
            next if amber_barrier.nil?
            {
              barrier: amber_barrier[:barrier],
              overview: amber_barrier[:overview],
              description: amber_barrier[:description]
            }
          end
        end

        new_catch_up[:overviewOfEngagement] = catch_up[:overviewOfEngagement]
        new_catch_up[:commentOnProgress] = catch_up[:commentOnProgress]
        new_catch_up[:issuesToRaise] = catch_up[:issuesToRaise]

        new_catch_up
      end
    end
  end

  def convert_outputs_actuals
    return if @return[:outputsActuals].nil?
    @converted_return[:outputsActuals] = {}

    @converted_return[:outputsActuals][:details] = {
      localAuthority: @return[:outputsActuals][:localAuthority],
      noOfUnits: @return[:outputsActuals][:noOfUnits],
      size: @return[:outputsActuals][:size]
    }

    @converted_return[:outputsActuals][:starts] = {}

    @converted_return[:outputsActuals][:starts][:starts] = {
      previousStarts: @return[:outputsActuals][:previousStarts],
      currentStarts: @return[:outputsActuals][:currentStarts],
      startsSinceLastReturn: @return[:outputsActuals][:startsSinceLastReturn],
      previousCompletions: @return[:outputsActuals][:previousCompletions],
      currentCompletions: @return[:outputsActuals][:currentCompletions],
      completionsSinceLastReturn: @return[:outputsActuals][:completionsSinceLastReturn]
    }

    @converted_return[:outputsActuals][:ownership] = {
      laOwned: @return[:outputsActuals][:laOwned],
      pslLand: @return[:outputsActuals][:pslLand]
    }

    @converted_return[:outputsActuals][:percentages] = {
      brownfieldPercent: @return[:outputsActuals][:brownfieldPercent],
      leaseholdPercent: @return[:outputsActuals][:leaseholdPercent],
      smePercent: @return[:outputsActuals][:smePercent],
      mmcPercent: @return[:outputsActuals][:mmcPercent]
    }
  end

  def convert_mr_review_tab
    return if @return[:reviewAndAssurance].nil?
    @converted_return[:reviewAndAssurance] = {}
    @converted_return[:reviewAndAssurance][:date] = @return[:reviewAndAssurance][:date]
    @converted_return[:reviewAndAssurance][:assuranceManagerAttendance] = @return[:reviewAndAssurance][:assuranceManagerAttendance]
    @converted_return[:reviewAndAssurance][:infrastructureDelivery] = @return[:reviewAndAssurance][:infrastructureDelivery].map do |delivery|
      {
        details: delivery[:details],
        riskRating: delivery[:riskRating]
      }
    end

    unless @return[:reviewAndAssurance][:hifFundedFinancials].nil?
      @converted_return[:reviewAndAssurance][:hifFundedFinancials] = {}
      @converted_return[:reviewAndAssurance][:hifFundedFinancials][:summary] = @return[:reviewAndAssurance][:hifFundedFinancials][:summary]
      @converted_return[:reviewAndAssurance][:hifFundedFinancials][:riskRating] = @return[:reviewAndAssurance][:hifFundedFinancials][:riskRating]
    end

    unless @return[:reviewAndAssurance][:hifWiderScheme].nil?
      @converted_return[:reviewAndAssurance][:hifWiderScheme] = {}
      @converted_return[:reviewAndAssurance][:hifWiderScheme][:summary] = @return[:reviewAndAssurance][:hifWiderScheme][:summary]
      @converted_return[:reviewAndAssurance][:hifWiderScheme][:riskRating] = @return[:reviewAndAssurance][:hifWiderScheme][:riskRating]
    end

    unless @return[:reviewAndAssurance][:outputForecast].nil?
      @converted_return[:reviewAndAssurance][:outputForecast] = {}
      @converted_return[:reviewAndAssurance][:outputForecast][:summary] = @return[:reviewAndAssurance][:outputForecast][:summary]
      @converted_return[:reviewAndAssurance][:outputForecast][:riskRating] = @return[:reviewAndAssurance][:outputForecast][:riskRating]
    end

    unless @return[:reviewAndAssurance][:barriers].nil?
      @converted_return[:reviewAndAssurance][:barriers] = {}
      @converted_return[:reviewAndAssurance][:barriers][:significantIssues] = @return[:reviewAndAssurance][:barriers][:significantIssues].map do |issue|
        {
          overview: issue[:overview],
          barrierType: issue[:barrierType],
          details: issue[:details]
        }
      end
    end

    unless @return[:reviewAndAssurance][:recommendForRegularMonitoring].nil?
      @converted_return[:reviewAndAssurance][:recommendForRegularMonitoring] = {}
      @converted_return[:reviewAndAssurance][:recommendForRegularMonitoring][:isRecommendForRegularMonitoring] = @return[:reviewAndAssurance][:recommendForRegularMonitoring][:isRecommendForRegularMonitoring]
      @converted_return[:reviewAndAssurance][:recommendForRegularMonitoring][:reasonAndProposedFrequency] = @return[:reviewAndAssurance][:recommendForRegularMonitoring][:reasonAndProposedFrequency]
    end
  end
end
