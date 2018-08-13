# frozen_string_literal: true

require 'rspec'
require_relative '../shared_context/use_case_factory'

describe 'Performing Return on HIF Project', focus: true do
  include_context 'use case factory'

  def update_return(id:, data:)
    get_use_case(:update_return).execute(return_id: id, data: data[:data])
  end

  def submit_return(id:)
    get_use_case(:submit_return).execute(return_id: id)
  end

  def create_new_return(return_data)
    get_use_case(:create_return).execute(return_data)[:id]
  end

  def expect_return_with_id_to_equal(id:, expected_return:)
    found_return = get_use_case(:get_return).execute(id: id)
    expect(found_return[:data]).to eq(expected_return[:data])
    expect(found_return[:status]).to eq(expected_return[:status])
    expect(found_return[:updates]).to eq(expected_return[:updates])
  end

  def expect_return_to_be_submitted(id:)
    found_return = get_use_case(:get_return).execute(id: id)
    expect(found_return[:status]).to eq('Submitted')
  end

  let(:project_baseline) do
    {
      financial: [
      {
        installments: [
        {
          dateOfInstallment: "2018-06-01",
            installmentAmount: "\u00a3 1,000,000"
        },
        {
          dateOfInstallment: "2018-09-01",
          installmentAmount: "\u00a3 1,000,000"
        }
        ],
        period: "2018/2019"
      },
      {
        baselineCashFlow: {
          summaryOfRequirement: ""
        },
        costs: [
        {
          costOfInfrastructure: "\u00a3 1,000,000",
          fundingStack: {
            descriptionOfFundingStack: "Description",
            totalPrivate: "\u00a3 500,000",
            totalPublic: "\u00a3 500,000",
            totallyFundedThroughHIF: false
          }
        }
        ],
        installments: [
        {
          dateOfInstallment: "2019-06-01",
          installmentAmount: "\u00a3 1,000,000"
        },
        {
          dateOfInstallment: "2019-09-01",
          installmentAmount: "\u00a3 1,000,000"
        }
        ],
        period: "2019/2020",
        recovery: {
          aimToRecover: true,
          expectedAmountToRecover: "\u00a3 100,000",
          methodOfRecovery: "method"
        }
      }
      ],
      infrastructures: [
      {
        description: "A house",
        expectedInfrastructureCompletion: {
          targetDateOfAchievingCompletion: "2019-06-01"
        },
        expectedInfrastructureStart: {
          targetDateOfAchievingStart: "2019-01-01"
        },
        fullPlanningStatus: {
          granted: false,
          grantedReference: "",
          summaryOfCriticalPath: "Summary of critical path",
          targetGranted: "2019-01-01",
          targetSubmission: "2019-01-01"
        },
        landOwnership: {
          howManySitesToAquire: 10,
          landAcquisitionRequired: true,
          ownershipOfLandOtherThanLA: "A",
          summaryOfCriticalPath: "Summary of critical path",
          targetDateToAquire: "2019-06-01",
          toBeAcquiredBy: "B",
          underOntrolOfLA: false
        },
        milestones: [
        {
          descriptionOfMilestone: "Milestone One",
          summaryOfCriticalPath: "Do the things",
          target: "2019-01-01"
        },
        {
          descriptionOfMilestone: "Milestone two",
          summaryOfCriticalPath: "Do more things",
          target: "2019-06-01"
        }
        ],
        outlinePlanningStatus: {
          granted: false,
          grantedReference: "",
          summaryOfCriticalPath: "Summary of critical path",
          targetGranted: "2019-01-01",
          targetSubmission: "2018-01-01"
        },
        procurement: {
          contractorProcured: true,
          nameOfContractor: "Super Contractor"
        },
        risksToAchievingTimescales: [
        {
          descriptionOfRisk: "Risk One",
          impactOfRisk: "Low",
          liklihoodOfRisk: "Low",
          mitigationOfRisk: "Don't do it"
        },
        {
          descriptionOfRisk: "Risk two",
          impactOfRisk: "High",
          liklihoodOfRisk: "High",
          mitigationOfRisk: "Really don't do it"
        }
        ],
        s106: {
          requirement: true,
          summaryOfRequirement: "This is a requirement"
        },
        statutoryConsents: {
          anyConsents: true,
          detailsOfConsent: "Consent details",
          targetDateToBeMet: "2019-06-01"
        },
        type: "house"
      },{
        description: "A house",
          expectedInfrastructureCompletion: {
            targetDateOfAchievingCompletion: "2019-06-01"
          },
          expectedInfrastructureStart: {
            targetDateOfAchievingStart: "2019-01-01"
          },
          fullPlanningStatus: {
            granted: false,
            grantedReference: "",
            summaryOfCriticalPath: "Summary of critical path",
            targetGranted: "2019-01-01",
            targetSubmission: "2019-01-01"
          },
          landOwnership: {
            howManySitesToAquire: 10,
            landAcquisitionRequired: true,
            ownershipOfLandOtherThanLA: "A",
            summaryOfCriticalPath: "Summary of critical path",
            targetDateToAquire: "2019-06-01",
            toBeAcquiredBy: "B",
            underOntrolOfLA: false
          },
          milestones: [
          {
            descriptionOfMilestone: "Milestone One",
            summaryOfCriticalPath: "Do the things",
            target: "2019-01-01"
          },
          {
            descriptionOfMilestone: "Milestone two",
            summaryOfCriticalPath: "Do more things",
            target: "2019-06-01"
          }
          ],
          outlinePlanningStatus: {
            granted: false,
            grantedReference: "",
            summaryOfCriticalPath: "Summary of critical path",
            targetGranted: "2019-01-01",
            targetSubmission: "2020-01-01"
          },
          procurement: {
            contractorProcured: true,
            nameOfContractor: "Super Contractor"
          },
          risksToAchievingTimescales: [
          {
            descriptionOfRisk: "Risk One",
            impactOfRisk: "Low",
            liklihoodOfRisk: "Low",
            mitigationOfRisk: "Don't do it"
          },
          {
            descriptionOfRisk: "Risk two",
            impactOfRisk: "High",
            liklihoodOfRisk: "High",
            mitigationOfRisk: "Really don't do it"
          }
          ],
          s106: {
            requirement: true,
            summaryOfRequirement: "This is a requirement"
          },
          statutoryConsents: {
            anyConsents: true,
            detailsOfConsent: "Consent details",
            targetDateToBeMet: "2019-06-01"
          },
          type: "house"
      }
      ],
      outputsActuals: {
        siteOutputs: [
        {
          siteLocalAuthority: "Site Local Authority",
          siteName: "Site name",
          siteNumberOfUnits: "10"
        }
        ]
      },
      outputsForecast: {
        disposalStrategy: "Disposal strategy",
        housingForecast: [
        {
          housingCompletions: "2019-01-01",
          housingStarts: "2018-01-01",
          target: "2019-01-01"
        },
        {
          housingCompletions: "2019-01-01",
          housingStarts: "2018-01-01",
          target: "2019-01-01"
        }
        ],
        totalUnits: 10
      },
      summary: {
        BIDReference: "123",
        descriptionOfInfrastructure: "Example description",
        descriptionOfWiderProjectDeliverables: "Example description",
        hifFundingAmount: 1234,
        leadAuthority: "Made Tech",
        noOfHousingSites: 1,
        projectDescription: "An example project",
        projectName: "Example project",
        totalArea: 1
      },
      s151: {
        s151FundingEndDate: "2019-01-01",
        s151ProjectLongstopDate: "2020-01-01"
      }
    }
  end

  let(:project_base_return) do
    {
      id: project_id,
      data:
      {
        infrastructure:
        [
          {
            outlinePlanningStatus:
            {
              targetSubmission: "2018-06-01",
              currentSubmission: "2018-06-01"
            }
          }
        ]
      },
    }
  end

  let(:project_id) do
    get_use_case(:create_new_project).execute(
      type: 'hif', baseline: project_baseline
    )[:id]
  end

  before do
    project_id
  end

  it 'should keep track of Returns' do
    base_return = get_use_case(:get_base_return).execute(project_id: project_id)
    expect(base_return[:base_return][:data]).to eq(project_base_return[:data])

    initial_return = {
      project_id: project_id,
      data: {
        summary: {
          project_name: 'Cats Protection League',
          description: 'A new headquarters for all the Cats',
          lead_authority: 'Made Tech'
        },
        infrastructure: {
          type: 'Cat Bathroom',
          description: 'Bathroom for Cats',
          completion_date: '2018-12-25',
          planning: {
            submission_estimated: '2018-06-01',
            submission_actual: '2018-07-01',
            submission_delay_reason: 'Planning office was closed for summer'
          }
        },
        financial: {
          total_amount_estimated: '£ 1000000.00',
          total_amount_actual: nil,
          total_amount_changed_reason: nil
        }
      }
    }

    return_id = create_new_return(
      project_id: initial_return[:project_id],
      data: initial_return[:data]
    )

    expected_initial_return = {
      project_id: project_id,
      status: 'Draft',
      updates: [
        initial_return[:data]
      ]
    }

    expect_return_with_id_to_equal(
      id: return_id,
      expected_return: expected_initial_return
    )

    updated_return_data = {
      summary: {
        project_name: 'Dogs Protection League',
        description: 'A new headquarters for all the Dogs',
        lead_authority: 'Made Tech'
      },
      infrastructure: {
        type: 'Dog Bathroom',
        description: 'Bathroom for Dogs',
        completion_date: '2018-12-25',
        planning: {
          submission_estimated: '2018-06-01',
          submission_actual: '2018-07-01',
          submission_delay_reason: 'Planning office was closed for summer'
        }
      },
      financial: {
        total_amount_estimated: '£ 1000000.00',
        total_amount_actual: nil,
        total_amount_changed_reason: nil
      }
    }

    soft_update_return(id: return_id, data: updated_return_data)
    soft_update_return(id: return_id, data: updated_return_data)

    expected_updated_return = {
      project_id: project_id,
      status: 'Draft',
      updates: [
        initial_return[:data],
        updated_return_data,
        updated_return_data
      ]
    }

    expect_return_with_id_to_equal(
      id: return_id,
      expected_return: expected_updated_return
    )

    submit_return(id: return_id)
    expect_return_to_be_submitted(id: return_id)
  end

  def soft_update_return(id:, data:)
    get_use_case(:soft_update_return).execute(return_id: id, return_data: data)
  end

  def update_return(id:, data:)
    get_use_case(:update_return).execute(return_id: id, data: data)
  end

  def submit_return(id:)
    get_use_case(:submit_return).execute(return_id: id)
  end
end
