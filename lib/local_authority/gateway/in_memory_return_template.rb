# frozen_string_literal: true

# noinspection RubyScope
class LocalAuthority::Gateway::InMemoryReturnTemplate
  def find_by(type:)
    return nil unless type == 'hif'
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {
        title: 'HIF Project',
        type: 'object',
        properties: {
          infrastructures: {
            type: 'array',
            title: 'Infrastructures',
            items: {
              title: 'Infrastructure',
              type: 'object',
              properties: {
                summary: {
                  type: 'object',
                  title: 'Summary',
                  properties: {
                    type: {
                      type: 'string',
                      title: 'Type',
                      sourceKey: %i[baseline_data infrastructures type],
                      readonly: true
                    },
                    description: {
                      type: 'string',
                      title: 'Description',
                      sourceKey: %i[baseline_data infrastructures description],
                      readonly: true
                    }
                  }
                },
                planning: {
                  type: 'object',
                  title: 'Planning',
                  properties: {
                    # Baseline
                    # from outlinePlanningStatus.granted
                    outlinePlanning: {
                      type: 'object',
                      title: 'Outline Planning',
                      properties: {
                        baselineOutlinePlanningPermissionGranted: {
                          type: 'string',
                          title: 'Outline Planning Permission granted',
                          sourceKey: %i[baseline_data infrastructures outlinePlanningStatus granted],
                          readonly: true,
                          enum: %w[Yes No]
                        }
                      },
                      dependencies: {
                        baselineOutlinePlanningPermissionGranted: {
                          oneOf: [
                            {
                              properties: {
                                baselineOutlinePlanningPermissionGranted: {
                                  enum: ['No']
                                },
                                baselineSummaryOfCriticalPath: {
                                  type: 'string',
                                  title: 'Summary Of Outline Planning Permission Critical Path',
                                  sourceKey: %i[baseline_data infrastructures outlinePlanningStatus summaryOfCriticalPath],
                                  readonly: true
                                },
                                planningSubmitted: {
                                  title: 'Planning permission Submitted',
                                  type: 'object',
                                  horizontal: true,
                                  required: ['percentComplete'],
                                  properties: {
                                    baselineSubmitted: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission submitted date',
                                      sourceKey: %i[baseline_data infrastructures outlinePlanningStatus targetSubmission],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Baseline submitted date (Week) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Last Return submitted date (Week) (Calculated)'
                                    },
                                    statusAgainstLastReturn: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'completed',
                                        'on schedule',
                                        'delayed: minimal impact',
                                        'delayed: critical'
                                      ],
                                      default: 'on schedule'
                                    },
                                    currentReturn: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reasonForVariance: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    onCompletedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      title: 'Completed date (Calculated)'
                                    },
                                    onCompletedReference: {
                                      type: 'string',
                                      readonly: true,
                                      title: 'Completed Reference (Calculated)'
                                    }
                                  }
                                },
                                planningGranted: {
                                  title: 'Planning Permission Granted',
                                  type: 'object',
                                  horizontal: true,
                                  properties: {
                                    baselineGranted: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Outline Planning Permission granted date',
                                      sourceKey: %i[baseline_data infrastructures outlinePlanningStatus targetGranted],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Baseline granted date (Weeks) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Last Return granted date (Weeks) (Calculated)'
                                    },
                                    statusAgainstLastReturn: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'completed',
                                        'on schedule',
                                        'delayed: minimal impact',
                                        'delayed: critical'
                                      ],
                                      default: 'on schedule'
                                    },
                                    currentReturn: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reasonForVariance: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    onCompletedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      title: 'Completed date (Calculated)'
                                    }
                                  }
                                },
                              }
                            }
                          ]
                        }
                      }
                    },
                    fullPlanning: {
                      type: 'object',
                      title: 'Outline Planning',
                      properties: {
                        fullPlanningPermissionGranted: {
                          type: 'string',
                          title: 'Full Planning Permission granted',
                          sourceKey: %i[baseline_data infrastructures fullPlanningStatus granted],
                          readonly: true,
                          enum: %w[Yes No]
                        }
                      },
                      dependencies: {
                        fullPlanningPermissionGranted: {
                          oneOf: [
                            {
                              properties: {
                                fullPlanningPermissionGranted: {
                                  enum: ['No']
                                },
                                fullPlanningPermissionSummaryOfCriticalPath: {
                                  type: 'string',
                                  title: 'Summary Of Full Planning Permission Critical Path',
                                  sourceKey: %i[baseline_data infrastructures fullPlanningStatus summaryOfCriticalPath],
                                  readonly: true
                                },
                                submitted: {
                                  title: 'Planning permission Submitted',
                                  type: 'object',
                                  horizontal: true,
                                  properties: {
                                    baselineFullPlanningPermissionSubmitted: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission submitted date',
                                      sourceKey: %i[baseline_data infrastructures fullPlanningStatus targetSubmission],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Baseline submitted date (Week) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Last Return submitted date (Week) (Calculated)'
                                    },
                                    statusAgainstLastReturn: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'completed',
                                        'on schedule',
                                        'delayed: minimal impact',
                                        'delayed: critical'
                                      ],
                                      default: 'on schedule'
                                    },
                                    currentReturn: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reasonForVariance: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    onCompletedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      title: 'Completed date (Calculated)'
                                    },
                                    onCompletedReference: {
                                      type: 'string',
                                      readonly: true,
                                      title: 'Completed Reference (Calculated)'
                                    }
                                  }
                                },
                                granted: {
                                  title: 'Planning Permission Granted',
                                  type: 'object',
                                  horizontal: true,
                                  properties: {
                                    baselineFullPlanningPermissionGranted: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission granted date',
                                      sourceKey: %i[baseline_data infrastructures fullPlanningStatus targetGranted],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Baseline granted date (Weeks) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'Variance against Last Return granted date (Weeks) (Calculated)'
                                    },
                                    statusAgainstLastReturn: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'completed',
                                        'on schedule',
                                        'delayed: minimal impact',
                                        'delayed: critical'
                                      ],
                                      default: 'on schedule'
                                    },
                                    currentReturn: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reasonForVariance: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    onCompletedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      title: 'Completed date (Calculated)'
                                    }
                                  }
                                },
                              }
                            }
                          ]
                        }
                      }
                    },
                    section106: {
                      title: 'Section 106',
                      type: 'object',
                      properties: {
                        # from s106.requirement
                        s106Requirement: {
                          type: 'string',
                          title: 'S106 Requirement',
                          sourceKey: %i[baseline_data infrastructures s106 requirement],
                          readonly: true,
                          items: {
                            type: 'string',
                            enum: %w[Yes No]
                          }
                        }
                      },
                      dependencies: {
                        s106Requirement: {
                          oneOf: [
                            {
                              properties: {
                                s106Requirement: {
                                  enum: ['Yes']
                                },
                                s106SummaryOfRequirement: {
                                  type: 'string',
                                  title: 'Summary of S016 Requirement ',
                                  sourceKey: %i[baseline_data infrastructures s106 summaryOfRequirement],
                                  readonly: true
                                },
                                # from statutoryConsents.anyConsents
                                statutoryConsents: {
                                  type: 'object',
                                  title: 'Statutory Consents',
                                  properties: {
                                    anyStatutoryConsents: {
                                      type: 'string',
                                      title: 'Statutory consents to be met?',
                                      sourceKey: %i[baseline_data infrastructures statutoryConsents anyConsents],
                                      readonly: true,
                                      items: {
                                        type: 'string',
                                        enum: %w[Yes No]
                                      }
                                    },
                                    statutoryConsents: {
                                      title: 'Current Statutory Consents',
                                      type: 'array',
                                      addable: true,
                                      items: {
                                        type: 'object',
                                        properties: {
                                          baselineCompletion: {
                                            title: 'Baseline completion',
                                            type: 'string',
                                            format: 'date'
                                          },
                                          varianceAgainstBaseline: {
                                            title: 'Variance against baseline (Calculated)',
                                            type: 'integer',
                                            readonly: true
                                          },
                                          varianceAgainstLastReturn: {
                                            title: 'Variance against last return (Calculated)',
                                            type: 'integer',
                                            readonly: true
                                          },
                                          statusAgainstLastReturn: status_against_last_return,
                                          currentReturn: {
                                            title: 'Current return',
                                            type: 'string',
                                            format: 'date'
                                          },
                                          varianceReason: {
                                            title: 'Reason for variance',
                                            type: 'string'
                                          },
                                          percentComplete: {
                                            title: 'Percentage complete',
                                            type: 'integer'
                                          },
                                          completionDate: {
                                            title: 'Completion date (Calculated)',
                                            type: 'string',
                                            format: 'date',
                                            readonly: true
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          ]
                        }
                      }
                    }
                  }
                },
                landOwnership: {
                  type: 'object',
                  title: 'Land Ownership',
                  properties: {
                    # from landOwnership.underControlOfLA
                    laHasControlOfSite: {
                      type: 'string',
                      title: 'LA Control of site(s) (related to infrastructure)? ',
                      sourceKey: %i[baseline_data infrastructures landOwnership landAcquisitionRequired],
                      readonly: true,
                      enum: %w[Yes No]
                    }
                  },
                  dependencies: {
                    laHasControlOfSite: {
                      oneOf: [
                        {
                          properties: {
                            laHasControlOfSite: {
                              enum: ['No']
                            },
                            laDoesNotControlSite: {
                              type: 'object',
                              title: 'Land ownership',
                              properties: {
                                # from  landOwnership.ownershipOfLandOtherThanLA
                                whoOwnsSite: {
                                  type: 'string',
                                  title: 'Who owns site?',
                                  sourceKey: %i[baseline_data infrastructures landOwnership ownershipOfLandOtherThanLA],
                                  readonly: true
                                },
                                # from landOwnership.landAcquisitionRequired
                                landAcquisitionRequired: {
                                  type: 'string',
                                  title: 'Land acquisition required (related to infrastructure)?',
                                  sourceKey: %i[baseline_data infrastructures landOwnership landAcquisitionRequired],
                                  readonly: true,
                                  enum: %w[Yes No]
                                }
                              },
                              dependencies: { 
                                landAcquisitionRequired: {
                                  oneOf: [
                                    {
                                      properties: {
                                        landAcquisitionRequired: {
                                          enum: ['Yes']
                                        },
                                        howManySitesToAquire: {
                                          type: 'integer',
                                          title: 'Number of Sites to aquire?',
                                          sourceKey: %i[baseline_data infrastructures landOwnership howManySitesToAcquire],
                                          readonly: true
                                        },
                                        # from landOwnership.toBeAquiredBy
                                        toBeAquiredBy: {
                                          type: 'string',
                                          title: 'Acquired by LA or Developer?',
                                          sourceKey: %i[baseline_data infrastructures landOwnership toBeAcquiredBy],
                                          readonly: true
                                        },
                                        # from landOwnership.summaryOfCriticalPath
                                        summaryOfAcquisitionRequired: {
                                          type: 'string',
                                          title: 'Summary of acquisition required',
                                          sourceKey: %i[baseline_data infrastructures landOwnership summaryOfCriticalPath],
                                          readonly: true
                                        },
                                        allLandAssemblyAchieved: {
                                          type: 'object',
                                          title: 'All land assembly achieved',
                                          horizontal: true,
                                          properties: {
                                            # from landOwnership.toBeAquiredBy
                                            landAssemblyBaselineCompletion: {
                                              type: 'string',
                                              format: 'date',
                                              title: 'Baseline Completion',
                                              sourceKey: %i[baseline_data infrastructures landOwnership targetDateToAcquire],
                                              readonly: true
                                            },
                                            # To be calculated
                                            landAssemblyVarianceAgainstLastReturn: {
                                              type: 'string',
                                              readonly: true,
                                              title: 'Variance Against Last Return (Calculated)'
                                            },
                                            # To be calculated
                                            landAssemblyVarianceAgainstBaseReturn: {
                                              type: 'string',
                                              readonly: true,
                                              title: 'Variance Against Base Return (Calculated)'
                                            },
                                            statusAgainstLastReturn: {
                                              title: 'Status against last return?',
                                              type: 'string',
                                              enum: [
                                                'completed',
                                                'on schedule',
                                                'delayed: minimal impact',
                                                'delayed: critical'
                                              ],
                                              default: 'on schedule'
                                            },
                                            currentReturn: {
                                              type: 'string',
                                              format: 'date',
                                              title: 'Current Return'
                                            },
                                            reasonForVariance: {
                                              type: 'string',
                                              title: 'Reason for Variance'
                                            },
                                            percentComplete: {
                                              type: 'integer',
                                              title: 'Percent complete'
                                            },
                                            landAssemblyCompletedDate: {
                                              type: 'string',
                                              format: 'date',
                                              readonly: true,
                                              title: 'On Completed date (Calculated)'
                                            }
                                          }
                                        }
                                      }
                                    }
                                  ]
                                }
                              }
                            }
                          }
                        }
                      ]
                    }
                  }
                },
                procurement: {
                  type: 'object',
                  title: 'Procurement',
                  properties: {
                    # from procurement.contractorProcured
                    contractorProcured: {
                      type: 'string',
                      title: 'Infrastructure contractor procured?',
                      sourceKey: %i[baseline_data infrastructures landOwnership procurement contractorProcured],
                      readonly: true,
                      items: {
                        type: 'string',
                        enum: %w[Yes No]
                      }
                    },
                  },
                  dependencies: {
                    contractorProcured: {
                      oneOf: [
                        {
                          properties: {
                            contractorProcured: {
                              enum: ['Yes']
                            },
                            infrastructureProcured: {
                              type: 'object',
                              title: 'Infrastructure procured',
                              properties: {
                                # from procurement.nameOfContractor
                                nameOfContractor: {
                                  sourceKey: %i[baseline_data infrastructures landOwnership procurement nameOfContractor],
                                  type: 'string',
                                  title: 'Name of Contractor',
                                  readonly: true
                                }
                              }
                            }
                          },
                        },
                        {
                          properties: {
                            contractorProcured: {
                              enum: ['No']
                            },
                            infrastructureNotProcured: {
                              type: 'object',
                              title: 'Infrastructure not procured',
                              properties: {
                                infraStructureContractorProcurement: {
                                  type: 'object',
                                  title: 'Infrastructure contractor procurement',
                                  properties: {
                                    # from procurement.targetDateToAquire
                                    procurementBaselineCompletion: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Target date of procuring',
                                      sourceKey: %i[baseline_data infrastructures landOwnership procurement targetDateToAquire],
                                      readonly: true
                                    },
                                    procurementVarianceAgainstLastReturn: {
                                      type: 'string',
                                      readonly: true,
                                      title: 'Variance against last return (Calculated)'
                                    },
                                    procurementVarianceAgainstBaseline: {
                                      type: 'string',
                                      readonly: true,
                                      title: 'Variance against baseline (Calculated)'
                                    },
                                    procurementStatusAgainstLastReturn: {
                                      type: 'object',
                                      title: 'Procurement Status Against Last Return',
                                      properties: {
                                        statusAgainstLastReturn: {
                                          title: 'Status against last return?',
                                          type: 'string',
                                          enum: [
                                            'completed',
                                            'on schedule',
                                            'delayed: minimal impact',
                                            'delayed: critical'
                                          ],
                                          default: 'on schedule'
                                        },
                                        currentReturn: {
                                          type: 'string',
                                          format: 'date',
                                          title: 'Current Return'
                                        },
                                        reasonForVariance: {
                                          type: 'string',
                                          title: 'Reason for Variance'
                                        }
                                      }
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    procurementCompletedDate: {
                                      type: 'string',
                                      readonly: true,
                                      title: 'Completion Date (Calculated)'
                                    },
                                    procurementCompletedNameOfContractor: {
                                      type: 'string',
                                      readonly: true,
                                      title: 'Completion Name of Contractor (Calculated)'
                                    }
                                  },
                                  # from procurement.summaryOfCriticalPath
                                  summaryOfCriticalPath: {
                                    sourceKey: %i[baseline_data infrastructures landOwnership procurement summaryOfCriticalPath],
                                    type: 'string',
                                    title: 'Summary of Critical Procurement Path',
                                    readonly: true
                                  }
                                }
                              }
                            }
                          },
                        }
                      ]
                    }
                  }
                },
                milestones: {
                  type: 'object',
                  title: 'Milestones',
                  properties: {
                    keyMilestones: {
                      type: 'array',
                      title: 'Key Project Milestones',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          # from milestones.target
                          description: {
                            sourceKey: %i[baseline_data infrastructures milestones descriptionOfMilestone],
                            readonly: true,
                            type: 'string',
                            title: 'Description'
                          },
                          milestoneBaselineCompletion: {
                            sourceKey: %i[baseline_data infrastructures milestones target],
                            readonly: true,
                            type: 'string',
                            format: 'date',
                            title: 'Completion Date'
                          },
                          # from milestones.summaryOfCriticalPath
                          milestoneSummaryOfCriticalPath: {
                            sourceKey: %i[baseline_data infrastructures milestones summaryOfCriticalPath],
                            type: 'string',
                            title: 'Summary of Baseline Critical Path',
                            readonly: true
                          },
                          milestoneVarianceAgainstLastReturn: {
                            type: 'string',
                            readonly: true,
                            title: 'Variance against last return (Calculated)'
                          },
                          milestoneVarianceAgainstBaseline: {
                            type: 'string',
                            readonly: true,
                            title: 'Variance against baseline (Calculated)'
                          },
                          statusAgainstLastReturn: status_against_last_return,
                          currentReturn: {
                            type: 'string',
                            format: 'date',
                            title: 'Current Return'
                          },
                          reasonForVariance: {
                            type: 'string',
                            title: 'Reason for Variance'
                          },
                          milestonePercentCompleted: {
                            type: 'integer',
                            title: 'Percent complete'
                          },
                          milestoneCompletedDate: {
                            type: 'string',
                            format: 'date',
                            readonly: true,
                            title: 'On Completed date (Calculated)'
                          }
                        }
                      }
                    },
                    additionalMilestones: {
                      type: 'array',
                      title: 'Additional Milestones',
                      addable: true,
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          # from milestones.target
                          description: {
                            type: 'string',
                            title: 'Description'
                          },
                          completion: {
                            type: 'string',
                            format: 'date',
                            title: 'Target date of completion'
                          },
                          # from milestones.summaryOfCriticalPath
                          criticalPath: {
                            type: 'string',
                            title: 'Summary of Critical Path'
                          }
                        }
                      }
                    },
                    previousMilestones: {
                      type: 'array',
                      title: 'Previous Milestones',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          # from milestones.target
                          description: {
                            sourceKey: %i[return_data infrastructures milestones additionalMilestones description],
                            readonly: true,
                            type: 'string',
                            title: 'Description'
                          },
                          milestoneBaselineCompletion: {
                            sourceKey: %i[return_data infrastructures milestones additionalMilestones completion],
                            readonly: true,
                            type: 'string',
                            format: 'date',
                            title: 'Completion Date'
                          },
                          # from milestones.summaryOfCriticalPath
                          milestoneSummaryOfCriticalPath: {
                            sourceKey: %i[return_data infrastructures milestones additionalMilestones criticalPath],
                            type: 'string',
                            title: 'Summary of Baseline Critical Path',
                            readonly: true
                          },
                          milestoneVarianceAgainstLastReturn: {
                            type: 'string',
                            readonly: true,
                            title: 'Variance against last return (Calculated)'
                          },
                          milestoneVarianceAgainstBaseline: {
                            type: 'string',
                            readonly: true,
                            title: 'Variance against baseline (Calculated)'
                          },
                          statusAgainstLastReturn: status_against_last_return,
                          currentReturn: {
                            type: 'string',
                            format: 'date',
                            title: 'Current Return'
                          },
                          reasonForVariance: {
                            type: 'string',
                            title: 'Reason for Variance'
                          },
                          milestonePercentCompleted: {
                            type: 'integer',
                            title: 'Percent complete'
                          },
                          milestoneCompletedDate: {
                            type: 'string',
                            format: 'date',
                            readonly: true,
                            title: 'On Completed date (Calculated)'
                          }
                        }
                      }
                    },
                    expectedInfrastructureStartOnSite: {
                      type: 'object',
                      title: 'Expected infrastructure start on site',
                      properties: {
                        milestoneExpectedInfrastructureStartBaseline: {
                          # from milestones.expectedInfrastructureStart
                          sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                          type: 'string',
                          title: 'Baseline Start on site',
                          readonly: true
                        },
                        milestoneExpectedInfrastructureStartVarianceAgaistLastReturn: {
                          type: 'string',
                          readonly: true,
                          title: 'Variance against last return (Calculated)'
                        },
                        milestoneExpectedInfrastructureStartVarianceAgaistBaseline: {
                          type: 'string',
                          readonly: true,
                          title: 'Variance against baseline (Calculated)'
                        },
                        milestoneExpectedInfrastructureStartStatusAgainstLastReturn: {
                          type: 'object',
                          title: 'Expected Infrastructure Start Status Against Last Return',
                          properties: {
                            statusAgainstLastReturn: {
                              title: 'Status against last return?',
                              type: 'string',
                              enum: [
                                'completed',
                                'on schedule',
                                'delayed: minimal impact',
                                'delayed: critical'
                              ],
                              default: 'on schedule'
                            },
                            currentReturn: {
                              type: 'string',
                              format: 'date',
                              title: 'Current Return'
                            },
                            reasonForVariance: {
                              type: 'string',
                              title: 'Reason for Variance'
                            }
                          }
                        },
                        milestoneExpectedInfrastructureStartCompletionDate: {
                          type: 'string',
                          format: 'date',
                          readonly: true,
                          title: 'On Completed date (Calculated)'
                        }
                      }
                    },
                    expectedCompletionDateOfInfra: {
                      type: 'object',
                      title: 'Expected Completion date of infra',
                      properties: {
                        milestoneExpectedInfrastructureCompletionBaseline: {
                          # from milestones.expectedInfrastructureCompletion
                          sourceKey: %i[baseline_data infrastructures expectedInfrastructureCompletion targetDateOfAchievingCompletion],
                          type: 'string',
                          title: 'Baseline Completion',
                          readonly: true
                        },
                        milestoneExpectedInfrastructureCompletionVarianceAgaistLastReturn: {
                          type: 'string',
                          readonly: true,
                          title: 'Variance against last return (Calculated)'
                        },
                        milestoneExpectedInfrastructureCompletionVarianceAgaistBaseline: {
                          type: 'string',
                          readonly: true,
                          title: 'Variance against baseline (Calculated)'
                        },
                        milestoneExpectedInfrastructureCompletionStatusAgainstLastReturn: {
                          type: 'object',
                          title: 'Expected Infrastructure Completion Status Against Last Return',
                          properties: {
                            statusAgainstLastReturn: {
                              title: 'Status against last return?',
                              type: 'string',
                              enum: [
                                'completed',
                                'on schedule',
                                'delayed: minimal impact',
                                'delayed: critical'
                              ],
                              default: 'on schedule'
                            },
                            currentReturn: {
                              type: 'string',
                              format: 'date',
                              title: 'Current Return'
                            },
                            reasonForVariance: {
                              type: 'string',
                              title: 'Reason for Variance'
                            }
                          }
                        },
                        milestoneExpectedInfrastructureCompletionCompletionDate: {
                          type: 'string',
                          format: 'date',
                          readonly: true,
                          title: 'On Completed date (Calculated)'
                        }
                      }
                    }
                  }
                },
                risks: {
                  type: 'object',
                  title: 'Risks',
                  properties: {
                    baselineRisks: {
                      type: 'array',
                      title: 'Baseline Risks',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          riskBaselineRisk: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales descriptionOfRisk],
                            type: 'string',
                            title: 'Description Of Risk',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.impactOfRisk
                          riskBaselineImpact: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales impactOfRisk],
                            type: 'string',
                            title: 'Impact',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.likelihoodOfRisk
                          riskBaselineLikelihood: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales likelihoodOfRisk],
                            type: 'string',
                            title: 'Likelihood',
                            readonly: true
                          },
                          riskCurrentReturnLikelihood: {
                            type: 'string',
                            title: 'Current Return Likelihood'
                          },
                          # from risksToAchievingTimescales.mitigationOfRisk
                          riskBaselineMitigationsInPlace: {
                            sourceKey: %i[baseline_data infrastructures risksToAchievingTimescales mitigationOfRisk],
                            type: 'string',
                            title: 'Mitigation in place',
                            readonly: true
                          },
                          riskAnyChange: {
                            type: 'string',
                            title: 'Any change in risk?',
                            items: {
                              type: 'string',
                              enum: %w[Yes No]
                            }
                          },
                          riskCurrentReturnMitigationsInPlace: {
                            type: 'string',
                            title: 'Current Return Mitigations in place'
                          },
                          riskMetDate: {
                            type: 'string',
                            format: 'date',
                            readonly: true,
                            title: 'Risk met date (Calculated)'
                          }
                        }
                      }
                    },
                    additionalRisks: {
                      type: 'array',
                      title: 'Any additional risks to baseline?',
                      addable: true,
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          description: {
                            type: 'string',
                            title: 'Description'
                          },
                          impact: {
                            type: 'integer',
                            title: 'Impact'
                          },
                          likelihood: {
                            type: 'integer',
                            title: 'Likelihood'
                          },
                          mitigations: {
                            type: 'string',
                            title: 'Mitigations in place'
                          }
                        }
                      }
                    },
                    previousRisks: {
                      type: 'array',
                      title: 'Previous Risks',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          riskBaselineRisk: {
                            sourceKey: %i[return_data infrastructures risks additionalRisks description],
                            type: 'string',
                            title: 'Description Of Risk',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.impactOfRisk
                          riskBaselineImpact: {
                            sourceKey: %i[return_data infrastructures risks additionalRisks impact],
                            type: 'string',
                            title: 'Impact',
                            readonly: true
                          },
                          # from risksToAchievingTimescales.likelihoodOfRisk
                          riskBaselineLikelihood: {
                            sourceKey: %i[return_data infrastructures risks additionalRisks likelihood],
                            type: 'string',
                            title: 'Likelihood',
                            readonly: true
                          },
                          riskCurrentReturnLikelihood: {
                            type: 'string',
                            title: 'Current Return Likelihood'
                          },
                          # from risksToAchievingTimescales.mitigationOfRisk
                          riskBaselineMitigationsInPlace: {
                            sourceKey: %i[return_data infrastructures risks additionalRisks mitigations],
                            type: 'string',
                            title: 'Mitigation in place',
                            readonly: true
                          },
                          riskAnyChange: {
                            type: 'string',
                            title: 'Any change in risk?',
                            items: {
                              type: 'string',
                              enum: %w[Yes No]
                            }
                          },
                          riskCurrentReturnMitigationsInPlace: {
                            type: 'string',
                            title: 'Current Return Mitigations in place'
                          },
                          riskMetDate: {
                            type: 'string',
                            format: 'date',
                            readonly: true,
                            title: 'Risk met date (Calculated)'
                          }
                        }
                      }
                    }
                  }
                },
                progress: {
                  type: 'object',
                  title: 'Progress',
                  properties: {
                    describeQuarterProgress: {
                      type: 'string',
                      title: 'Describe progress for last quarter'
                    },
                    progressAgainstActions: {
                      type: 'array',
                      title: 'Progress against Actions',
                      items: {
                        type: 'object',
                        horizontal: true,
                        properties: {
                          description: {
                            sourceKey: %i[return_data infrastructures progress actionsForNextQuarter description],
                            type: 'string',
                            readonly: true,
                            # from actions for next quarter
                            title: 'Description of live action (Calculated)'
                          },
                          met: {
                            type: 'string',
                            title: 'Action Met?',
                            items: {
                              type: 'string',
                              enum: %w[Yes No]
                            }
                          },
                          progress: {
                            type: 'string',
                            title: 'Progress against action if not met'
                          }
                        }
                      }
                    },
                    actionsForNextQuarter: {
                      type: 'array',
                      title: 'Actions for next quarter',
                      addable: true,
                      items: {
                        type: 'object',
                        properties: {
                          description: {
                            type: 'string',
                            title: 'Action Description'
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          funding: {
            type: 'array',
            title: 'HIF Funding',
            items: {
              title: 'Funding Stack',
              type: 'object',
              properties: {
                summary: {
                  title: 'Summary',
                  type: 'object',
                  properties: {
                    hifFundingRequest: {
                      type: 'string',
                      # from s§151 (not done yet)
                      title: 'HIF Funding Request'
                    }
                  }
                },
                hifFundingProfiles: {
                  type: 'object',
                  title: 'Funding Profiles',
                  properties: {
                    hifFundingProfile: {
                      type: 'array',
                      title: 'Funding Profile',
                      items: {
                        type: 'object',
                        properties: {
                          fundingYear: {
                            type: 'string',
                            # from items.instalments.baselineInstalments.baselineInstalmentYear
                            title: 'Funding Year',
                            sourceKey: %i[baseline_data financial instalments baselineInstalments baselineInstalmentYear],
                            readonly: true
                          },
                          forecast: {
                            type: 'object',
                            title: 'Forecast',
                            horizontal: true,
                            properties: {
                              forecastQ1: {
                                type: 'string',
                                # from items.instalments.baselineInstalments.baselineInstalmentQ1
                                title: 'Forecast Q1',
                                sourceKey: %i[baseline_data financial instalments baselineInstalments baselineInstalmentQ1],
                                readonly: true
                              },
                              forecastQ2: {
                                type: 'string',
                                # from items.instalments.baselineInstalments.baselineInstalmentQ2
                                title: 'Forecast Q2',
                                sourceKey: %i[baseline_data financial instalments baselineInstalments baselineInstalmentQ2],
                                readonly: true
                              },
                              forecastQ3: {
                                type: 'string',
                                # from items.instalments.baselineInstalments.baselineInstalmentQ3
                                title: 'Forecast Q3',
                                sourceKey: %i[baseline_data financial instalments baselineInstalments baselineInstalmentQ3],
                                readonly: true
                              },
                              forecastQ4: {
                                type: 'string',
                                # from items.instalments.baselineInstalments.baselineInstalmentQ4
                                title: 'Forecast Q4',
                                sourceKey: %i[baseline_data financial instalments baselineInstalments baselineInstalmentQ4],
                                readonly: true
                              },
                              forecastTotal: {
                                type: 'string',
                                # from items.instalments.baselineInstalments.baselineInstalmentTotal
                                title: 'Forecast Total',
                                sourceKey: %i[baseline_data financial instalments baselineInstalments baselineInstalmentTotal],
                                readonly: true
                              }
                            }
                          },
                          actual: {
                            type: 'object',
                            title: 'Actual',
                            horizontal: true,
                            properties: {
                              forecastQ1: {
                                type: 'string',
                                readonly: true,
                                title: 'Actual Q1 (Calculated)'
                              },
                              forecastQ2: {
                                type: 'string',
                                readonly: true,
                                title: 'Actual Q2 (Calculated)'
                              },
                              forecastQ3: {
                                type: 'string',
                                readonly: true,
                                title: 'Actual Q3 (Calculated)'
                              },
                              forecastQ4: {
                                type: 'string',
                                readonly: true,
                                title: 'Actual Q4 (Calculated)'
                              },
                              forecastTotal: {
                                type: 'string',
                                readonly: true,
                                title: 'Actual Total (Calculated)'
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                changes: {
                  type: 'object',
                  title: 'Changes',
                  properties: {
                    hifConfirmNoChanges: {
                      type: 'string',
                      title: 'Please confirm there are no changes to be made to the funding profile',
                      enum: ['Confirm', 'Changes requested']
                    },
                    hifIfFundingChangeRequested: {
                      type: 'string',
                      title: 'If change requested, reason for request'
                    },
                    changeMitigation: {
                      type: 'string',
                      title: 'Mitigation in place to reduce further slippage'
                    },
                    hifRequestedProfile: {
                      type: 'array',
                      title: 'Funding Change',
                      addable: true,
                      items: {
                        type: 'object',
                        properties: {
                          fundingYear: {
                            type: 'string',
                            title: 'Requested period'
                          },
                          newProfile: {
                            type: 'object',
                            title: 'New Profile',
                            horizontal: true,
                            properties: {
                              newProfileQ1: {
                                type: 'string',
                                title: 'New Profile Q1'
                              },
                              newProfileQ2: {
                                type: 'string',
                                title: 'New Profile Q2'
                              },
                              newProfileQ3: {
                                type: 'string',
                                title: 'New Profile Q3'
                              },
                              newProfileQ4: {
                                type: 'string',
                                title: 'New Profile Q4'
                              },
                              newProfileTotal: {
                                type: 'string',
                                title: 'New Profile Total (Calculated)'
                              }
                            }
                          },
                          variance: {
                            type: 'object',
                            title: 'Variance',
                            horizontal: true,
                            properties: {
                              varianceQ1: {
                                type: 'string',
                                readonly: true,
                                title: 'Variance Q1 (Calculated)'
                              },
                              varianceQ2: {
                                type: 'string',
                                readonly: true,
                                title: 'Variance Q2 (Calculated)'
                              },
                              varianceQ3: {
                                type: 'string',
                                readonly: true,
                                title: 'Variance Q3 (Calculated)'
                              },
                              varianceQ4: {
                                type: 'string',
                                readonly: true,
                                title: 'Variance Q4 (Calculated)'
                              },
                              varianceTotal: {
                                type: 'string',
                                readonly: true,
                                title: 'Variance Total (Calculated)'
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                fundingPackages: {
                  type: 'array',
                  title: 'Funding Packages',
                  items: {
                    type: 'object',
                    properties: {
                      fundingPackage: {
                        title: 'Funding package',
                        type: 'object',
                        properties: {
                          overview: {
                            type: 'object',
                            title: 'Overview',
                            properties: {
                              overviewCosts: {
                                type: 'object',
                                title: 'Overview Costs',
                                horizontal: true,
                                properties: {
                                  # finances.costs.costOfInfrastructure
                                  baselineCost: {
                                    sourceKey: %i[baseline_data financial costs costOfInfrastructure],
                                    type: 'integer',
                                    title: 'Cost of Infrastructure',
                                    readonly: true
                                  },
                                  currentCostReturn: {
                                    type: 'integer',
                                    title: 'Current Cost Return'
                                  },
                                  lastCostReturn: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'Last Cost Return (Calculated)'
                                  },
                                  varianceCostAgainstBaseline: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'Variance against Baseline (Calculated)'
                                  },
                                  varianceCostAgainstLastReturn: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'Variance against last Return (Calculated)'
                                  },
                                  reasonForCostVariance: {
                                    type: 'string',
                                    title: 'Reason for Variance'
                                  },
                                  completedProgressBar: {
                                    type: 'integer',
                                    title: 'Percent complete'
                                  },
                                  costFinalAmount: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'Cost Final Amount (Calculated)'
                                  },
                                  costReasonForVariance: {
                                    type: 'string',
                                    readonly: true,
                                    title: 'Reason for Variance (Calculated)'
                                  }
                                }
                              },
                              hifSpendSinceLastReturn: {
                                type: 'object',
                                title: 'HIF Spend since last return',
                                horizontal: true,
                                properties: {
                                  hifSpendCurrentReturn: {
                                    type: 'integer',
                                    title: 'Current HIF spend since last return'
                                  },
                                  hifSpendLastReturn: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'Current HIF spend since last return (Calculated)',
                                    sourceKey: %i[return_data funding fundingPackages fundingPackage overview hifSpendSinceLastReturn hifSpendCurrentReturn]
                                  },
                                  hifSpendVariance: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'Current HIF spend variance (Calculated)'
                                  },
                                  hifSpendRemaining: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'Current HIF spend remaining (Calculated)'
                                  }
                                }
                              }
                            }
                          },
                          fundingStack: {
                            type: 'object',
                            title: 'Funding Stack',
                            properties: {
                              # from costs.fundingstack.totallyFundedThroughHIF
                              totallyFundedThroughHIF: {
                                sourceKey: %i[baseline_data financial costs fundingStack totallyFundedThroughHIF],
                                type: 'string',
                                title: 'Totally funded through HIF?',
                                readonly: true,
                                items: {
                                  type: 'string',
                                  enum: %w[Yes No]
                                }
                              },
                              # if totallFundedThroughHIF == false
                              notFundedThroughHif: {
                                type: 'object',
                                title: 'Not Funded Through HIF',
                                properties: {
                                  # from costs.fundingstack.descriptionOfFundingStack
                                  descriptionOfFundingStack: {
                                    sourceKey: %i[baseline_data financial costs fundingStack descriptionOfFundingStack],
                                    type: 'string',
                                    title: 'Description of Funding Stack',
                                    readonly: true
                                  },
                                  riskToFundingPackage: {
                                    type: 'string',
                                    title: 'Risk to funding package',
                                    items: {
                                      type: 'string',
                                      enum: %w[Yes No]
                                    }
                                  },
                                  # if riskToFundingPackage = true
                                  riskToFundingPackageDescription: {
                                    type: 'string',
                                    title: 'Risk to funding package Description'
                                  },
                                  totalPublic: {
                                    type: 'object',
                                    title: 'Total Public',
                                    horizontal: true,
                                    properties: {
                                      # from costs.fundingStack.totalPublic.
                                      publicTotalBaselineAmount: {
                                        sourceKey: %i[baseline_data financial costs fundingStack totalPublic],
                                        type: 'integer',
                                        title: 'Total Public Baseline Amount',
                                        readonly: true
                                      },
                                      publicTotalCurrentReturn: {
                                        type: 'integer',
                                        title: 'Total Public Current Amount'
                                      },
                                      publicTotalLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Total Last Return (Calculated)'
                                      },
                                      publicVarianceAgainstBaseline: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Variance against Baseline (Calculated)'
                                      },
                                      publicVarianceAgainstLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Variance against Last Return (Calculated)'
                                      },
                                      publicReasonForVariance: {
                                        type: 'string',
                                        title: 'Reason for Variance'
                                      },
                                      publicAmountSecuredToDate: {
                                        type: 'integer',
                                        title: 'Amount Secured To Date'
                                      },
                                      publicSecuredAgaintBaselinePercent: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Secured against Baseline (Calculated)'
                                      },
                                      publicIncreaseOnLastReturnAmount: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Increase on Last Return Amount (Calculated)'
                                      },
                                      publicIncreaseOnLastReturnPercent: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Increase on Last Return Percent (Calculated)'
                                      },
                                      publicRemainingToBeSecured: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Remaining to be secured (Calculated)'
                                      }
                                    }
                                  },
                                  totalPrivate: {
                                    type: 'object',
                                    title: 'Total Private',
                                    horizontal: true,
                                    properties: {
                                      # from costs.fundingStack.totalPrivate
                                      privateTotalBaselineAmount: {
                                        sourceKey: %i[baseline_data financial costs fundingStack totalPrivate],
                                        type: 'integer',
                                        title: 'Total Private Baseline Amount',
                                        readonly: true
                                      },
                                      privateTotalCurrentReturn: {
                                        type: 'integer',
                                        title: 'Total Private Current Amount'
                                      },
                                      privateTotalLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Total Last Return (Calculated)'
                                      },
                                      privateVarianceAgainstBaseline: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Variance against Baseline (Calculated)'
                                      },
                                      privateVarianceAgainstLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Variance against Last Return (Calculated)'
                                      },
                                      privateReasonForVariance: {
                                        type: 'string',
                                        title: 'Reason for Variance'
                                      },
                                      privateAmountSecuredToDate: {
                                        type: 'integer',
                                        title: 'Amount Secured To Date'
                                      },
                                      privateSecuredAgaintBaselinePercent: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Secured against Baseline (Calculated)'
                                      },
                                      privateIncreaseOnLastReturnAmount: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Increase on Last Return Amount (Calculated)'
                                      },
                                      privateIncreaseOnLastReturnPercent: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Increase on Last Return Percent (Calculated)'
                                      },
                                      privateRemainingToBeSecured: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'Remaining to be secured (Calculated)'
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                recovery: {
                  type: 'object',
                  title: 'Recovery',
                  properties: {
                    # from costs.recovery.aimToRecover
                    aimToRecover: {
                      sourceKey: %i[baseline_data financial recovery aimToRecover],
                      type: 'string',
                      title: 'Aim to recover any funding?',
                      readonly: true,
                      items: {
                        type: 'string',
                        enum: %w[Yes No]
                      }
                    },
                    amountToRecover: {
                      sourceKey: %i[baseline_data financial recovery expectedAmountToRemove],
                      title: 'Amount to recover',
                      type: 'string',
                      readonly: true
                    },
                    # if aimToRecover is true
                    methodOfRecovery: {
                      type: 'string',
                      title: 'If Yes: Method of recovery'
                    }
                  }
                }
              }
            }
          }
        }
      }

      p.layout = {
        summary: {
          project_name: nil,
          description: nil,
          lead_authority: nil
        },
        infrastructure: {
          type: nil,
          description: nil,
          completion_date: nil,
          planning: {
            submission_estimated: nil,
            submission_actual: nil,
            submission_delay_reason: nil
          }
        },
        financial: {
          total_amount_estimated: nil,
          total_amount_actual: nil,
          total_amount_changed_reason: nil
        }
      }
    end
  end

  private

  def status_against_last_return
    {
      title: 'Status against last return?',
      type: 'string',
      enum: [
        'completed',
        'on schedule',
        'delayed: minimal impact',
        'delayed: critical'
      ],
      default: 'on schedule'
    }
  end
end
