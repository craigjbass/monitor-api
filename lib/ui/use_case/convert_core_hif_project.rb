# frozen_string_literal: true

class UI::UseCase::ConvertCoreHIFProject
  def execute(project_data:)
    @project = project_data
    @converted_project = {}

    convert_project_summary
    convert_infrastructures
    convert_funding_profiles
    convert_costs
    convert_baseline_cash_flow
    convert_recovery
    convert_s151
    convert_outputs_forecast
    convert_outputs_actuals

    @converted_project
  end

  private

  def convert_project_summary
    @converted_project[:summary] = {
      BIDReference: @project[:summary][:BIDReference],
      projectName: @project[:summary][:projectName],
      leadAuthority: @project[:summary][:leadAuthority],
      jointBidAreas: @project[:summary][:jointBidAreas],
      projectDescription: @project[:summary][:projectDescription],
      greenOrBrownField: @project[:summary][:greenOrBrownField],
      noOfHousingSites: @project[:summary][:noOfHousingSites],
      totalArea: @project[:summary][:totalArea],
      hifFundingAmount: @project[:summary][:hifFundingAmount],
      descriptionOfInfrastructure: @project[:summary][:descriptionOfInfrastructure],
      descriptionOfWiderProjectDeliverables: @project[:summary][:descriptionOfWiderProjectDeliverables]
    }
  end

  def convert_infrastructures
    @converted_project[:infrastructures] = []
    @project[:infrastructures].each do |infrastructure|
      @converted_project[:infrastructures] << {
        type: infrastructure[:type],
        description: infrastructure[:description],
        housingSitesBenefitting: infrastructure[:housingSitesBenefitting],
        outlinePlanningStatus: {
          granted: infrastructure[:outlinePlanningStatus][:granted],
          reference: infrastructure[:outlinePlanningStatus][:reference],
          targetSubmission: infrastructure[:outlinePlanningStatus][:targetSubmission],
          targetGranted: infrastructure[:outlinePlanningStatus][:targetGranted],
          summaryOfCriticalPath: infrastructure[:outlinePlanningStatus][:summaryOfCriticalPath]
        },
        fullPlanningStatus: {
          granted: infrastructure[:fullPlanningStatus][:granted],
          grantedReference: infrastructure[:fullPlanningStatus][:grantedReference],
          targetSubmission: infrastructure[:fullPlanningStatus][:targetSubmission],
          targetGranted: infrastructure[:fullPlanningStatus][:targetGranted],
          summaryOfCriticalPath: infrastructure[:fullPlanningStatus][:summaryOfCriticalPath]
        },
        s106: {
          requirement: infrastructure[:s106][:requirement],
          summaryOfRequirement: infrastructure[:s106][:summaryOfRequirement]
        },
        statutoryConsents: {
          anyConsents: infrastructure[:statutoryConsents][:anyConsents],
          consents: infrastructure[:statutoryConsents][:consents].map do |consent|
            {
              detailsOfConsent: consent[:detailsOfConsent],
              targetDateToBeMet: consent[:targetDateToBeMet]
            }
          end
        },
        landOwnership: {
          underControlOfLA: infrastructure[:landOwnership][:underControlOfLA],
          ownershipOfLandOtherThanLA: infrastructure[:landOwnership][:ownershipOfLandOtherThanLA],
          landAcquisitionRequired: infrastructure[:landOwnership][:landAcquisitionRequired],
          howManySitesToAcquire: infrastructure[:landOwnership][:howManySitesToAcquire],
          toBeAcquiredBy: infrastructure[:landOwnership][:toBeAcquiredBy],
          targetDateToAcquire: infrastructure[:landOwnership][:targetDateToAcquire],
          summaryOfCriticalPath: infrastructure[:landOwnership][:summaryOfCriticalPath]
        },
        procurement: {
          contractorProcured: infrastructure[:procurement][:contractorProcured],
          nameOfContractor: infrastructure[:procurement][:nameOfContractor],
          targetDate: infrastructure[:procurement][:targetDate],
          summaryOfCriticalPath: infrastructure[:procurement][:summaryOfCriticalPath]
        },
        milestones: infrastructure[:milestones].map do |milestone|
          {
            descriptionOfMilestone: milestone[:descriptionOfMilestone],
            target: milestone[:target],
            summaryOfCriticalPath: milestone[:summaryOfCriticalPath]
          }
        end,
        expectedInfrastructureStart: {
          targetDateOfAchievingStart: infrastructure[:expectedInfrastructureStart][:targetDateOfAchievingStart]
        },
        expectedInfrastructureCompletion: {
          targetDateOfAchievingCompletion: infrastructure[:expectedInfrastructureCompletion][:targetDateOfAchievingCompletion]
        },
        risksToAchievingTimescales: infrastructure[:risksToAchievingTimescales].map do |risk|
          {
            descriptionOfRisk: risk[:descriptionOfRisk],
            impactOfRisk: risk[:impactOfRisk],
            likelihoodOfRisk: risk[:likelihoodOfRisk],
            mitigationOfRisk: risk[:mitigationOfRisk]
          }
        end
      }
    end
  end

  def convert_funding_profiles
    @converted_project[:fundingProfiles] = @project[:fundingProfiles].map do |profile|
      {
        period: profile[:period],
        instalment1: profile[:instalment1],
        instalment2: profile[:instalment2],
        instalment3: profile[:instalment3],
        instalment4: profile[:instalment4],
        total: profile[:total]
      }
    end
  end

  def convert_costs
    @converted_project[:costs] = @project[:costs].map do |cost|
      {
        infrastructure: {
          HIFAmount: cost[:infrastructure][:HIFAmount],
          totalCostOfInfrastructure: cost[:infrastructure][:totalCostOfInfrastructure],
          totallyFundedThroughHIF: cost[:infrastructure][:totallyFundedThroughHIF],
          descriptionOfFundingStack: cost[:infrastructure][:descriptionOfFundingStack],
          totalPublic: cost[:infrastructure][:totalPublic],
          totalPrivate: cost[:infrastructure][:totalPrivate]
        }
      }
    end
  end

  def convert_baseline_cash_flow
    @converted_project[:baselineCashFlow] = {
      summaryOfRequirement: @project[:baselineCashFlow][:summaryOfRequirement]
    }
  end

  def convert_recovery
    @converted_project[:recovery] = {
      aimToRecover: @project[:recovery][:aimToRecover],
      expectedAmountToRecover: @project[:recovery][:expectedAmountToRecover],
      methodOfRecovery: @project[:recovery][:methodOfRecovery]
    }
  end

  def convert_s151
    @converted_project[:s151] = {
      s151FundingEndDate: @project[:s151][:s151FundingEndDate],
      s151ProjectLongstopDate: @project[:s151][:s151ProjectLongstopDate]
    }
  end

  def convert_outputs_forecast
    @converted_project[:outputsForecast] = {
      totalUnits: @project[:outputsForecast][:totalUnits],
      disposalStrategy: @project[:outputsForecast][:disposalStrategy],
      housingForecast: @project[:outputsForecast][:housingForecast].map do |forecast|
        {
          period: forecast[:period],
          target: forecast[:target],
          housingCompletions: forecast[:housingCompletions]
        }
      end
    }
  end

  def convert_outputs_actuals
    @converted_project[:outputsActuals] = {
      siteOutputs: @project[:outputsActuals][:siteOutputs].map do |output|
        {
          siteName: output[:siteName],
          siteLocalAuthority: output[:siteLocalAuthority],
          siteNumberOfUnits: output[:siteNumberOfUnits]
        }
      end
    }
  end
end
