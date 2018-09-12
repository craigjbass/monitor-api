# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Validates HIF return' do
  include_context 'use case factory'

  context 'Invalid HIF return' do
    # percent complete set to > 100
    let(:project_base_return_invalid) do
      {
        infrastructures: [
          {
            summary: {
              type: 'A House',
              description: 'A house of cats'
            },
            planning: {
              baselineOutlinePlanningPermissionGranted: true,
              planningNotGranted: {
                baselineSummaryOfCriticalPath: 'Summary of critical path',
                outlinePlanning: {
                  submitted: {
                    baselineCompletion: {
                      baselineFullPlanningPermissionSubmitted: '2020-01-01',
                      baselineFullPlanningPermissionGranted: '2020-01-01'
                    },
                    fullPlanningPermissionGranted: false,
                    fullPlanningPermissionSummaryOfCriticalPath: 'Summary of critical path'
                  },
                  granted: {
                    baselineCompletion: {
                      baselineFullPlanningPermissionSubmitted: '2020-01-01',
                      baselineFullPlanningPermissionGranted: '2020-01-01'
                    }
                  },
                },
                s106Requirement: true,
                s106SummaryOfRequirement: 'Required',
                statutoryConsents: {
                  anyStatutoryConsents: true
                }
              }
            },
            landOwnership: {
              laHasControlOfSite: true,
              laDoesNotControlSite: {
                whoOwnsSite: 'Dave',
                landAquisitionRequired: true
              },
              laDoesHaveControlOfSite: {
                howManySitesToAquire: 10,
                toBeAquiredBy: 'Dave',
                summaryOfAcquisitionRequired: 'Summary of critical path',
                allLandAssemblyAchieved: {
                  landAssemblyBaselineCompletion: '2020-01-01'
                }
              }
            },
            procurement: {
              contractorProcured: true,
              infrastructureNotProcured: {
                infraStructureContractorProcurement: {
                  procurementBaselineCompletion: '2020-01-01'
                }
              },
              infrastructureProcured: {
                nameOfContractor: 'Dave'
              }
            },
            milestones: {
              keyMilestones: [{ milestoneBaselineCompletion: '2020-01-01',
                                milestoneSummaryOfCriticalPath: 'Summary of critical path' }],
              expectedInfrastructureStartOnSite: {
                milestoneExpectedInfrastructureStartBaseline: '2020-01-01'
              },
              expectedCompletionDateOfInfra: {
                milestoneExpectedInfrastructureCompletionBaseline: '2020-01-01'
              }
            },
            risks: {
              baselineRisks: {
                risks: [{ items: {
                  riskBaselineRisk: 'Risk one',
                  riskBaselineImpact: 'High',
                  riskBaselineLikelihood: 'High',
                  riskBaselineMitigationsInPlace: 'Do not do the thing'
                } }]
              }
            }
          }
        ],
        funding: [
          {
            hifFundingProfiles: {
              hifFundingProfile: [
                {
                  fundingYear: ['4000'],
                  forecast: {
                    forecastQ1: ['1000'],
                    forecastQ2: ['1000'],
                    forecastQ3: ['1000'],
                    forecastQ4: ['1000'],
                    forecastTotal: ['1000']
                  }
                }
              ]
            }, fundingPackages: [
              {
                fundingPackage: {
                  overview: {
                    overviewCosts: {
                      baselineCost: '1000'
                    }
                  },
                  fundingStack: {
                    totallyFundedThroughHIF: true,
                    notFundedThroughHif: {
                      descriptionOfFundingStack: 'Stack',
                      totalPublic: {
                        publicTotalBaselineAmount: '2000'
                      },
                      totalPrivate: { privateTotalBaselineAmount: '2000' }
                    }
                  }
                }
              }
            ], recovery: { aimToRecover: true }
          }
        ]

      }
    end
    it 'should return invalid if fails validation' do
      valid_return = get_use_case(:validate_return).execute(type: 'hif', return_data: project_base_return_invalid)
      expect(valid_return[:valid]).to eq(false)
      expect(valid_return[:invalid_paths]).to eq([[:infrastructures, 0, :planning, :planningNotGranted, :outlinePlanning, :submitted, :percentComplete]])
    end
  end
end
