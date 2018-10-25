# frozen_string_literal: true

# noinspection RubyScope
class LocalAuthority::Gateway::InMemoryReturnTemplate
  def find_by(type:)
    return nil unless type == 'hif'
    return_template = LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
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
                          enum: %w[Yes No N/A]
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
                                  title: 'Planning Permission Submitted',
                                  type: 'object',
                                  variance: true,
                                  required: ['percentComplete'],
                                  properties: {
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission submitted date',
                                      sourceKey: %i[baseline_data infrastructures outlinePlanningStatus targetSubmission],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Baseline submitted date (Week) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Last Return submitted date (Week) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent Complete'
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Completed date (Calculated)'
                                    },
                                    onCompletedReference: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Completed Reference (Calculated)'
                                    }
                                  }
                                },
                                planningGranted: {
                                  title: 'Planning Permission Granted',
                                  type: 'object',
                                  variance: true,
                                  properties: {
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Outline Planning Permission granted date',
                                      sourceKey: %i[baseline_data infrastructures outlinePlanningStatus targetGranted],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Baseline granted date (Weeks) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Last Return granted date (Weeks) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Completed date (Calculated)'
                                    }
                                  }
                                }
                              }
                            },
                            {
                              properties: {
                                baselineOutlinePlanningPermissionGranted: {
                                  enum: ['Yes']
                                }
                              }
                            },
                            {
                              properties: {
                                baselineOutlinePlanningPermissionGranted: {
                                  enum: ['N/A']
                                }
                              }
                            }
                          ]
                        }
                      }
                    },
                    fullPlanning: {
                      type: 'object',
                      title: 'Full Planning',
                      properties: {
                        fullPlanningPermissionGranted: {
                          type: 'string',
                          title: 'Full Planning Permission granted',
                          sourceKey: %i[baseline_data infrastructures fullPlanningStatus granted],
                          readonly: true,
                          enum: %w[Yes No N/A]
                        }
                      },
                      dependencies: {
                        fullPlanningPermissionGranted: {
                          oneOf: [
                            {
                              type: 'object',
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
                                  variance: true,
                                  properties: {
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission submitted date',
                                      sourceKey: %i[baseline_data infrastructures fullPlanningStatus targetSubmission],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Baseline submitted date (Week) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Last Return submitted date (Week) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Completed date (Calculated)'
                                    },
                                    onCompletedReference: {
                                      type: 'string',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Completed Reference (Calculated)'
                                    }
                                  }
                                },
                                granted: {
                                  title: 'Planning Permission Granted',
                                  type: 'object',
                                  variance: true,
                                  properties: {
                                    baseline: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Full Planning Permission granted date',
                                      sourceKey: %i[baseline_data infrastructures fullPlanningStatus targetGranted],
                                      readonly: true
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Baseline granted date (Weeks) (Calculated)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Variance against Last Return granted date (Weeks) (Calculated)'
                                    },
                                    status: {
                                      title: 'Status against last return?',
                                      type: 'string',
                                      enum: [
                                        'Completed',
                                        'On schedule',
                                        'Delayed'
                                      ],
                                      default: 'On schedule'
                                    },
                                    current: {
                                      type: 'string',
                                      format: 'date',
                                      title: 'Current Return'
                                    },
                                    reason: {
                                      type: 'string',
                                      title: 'Reason for Variance'
                                    },
                                    percentComplete: {
                                      type: 'integer',
                                      title: 'Percent complete'
                                    },
                                    completedDate: {
                                      type: 'string',
                                      format: 'date',
                                      readonly: true,
                                      hidden: true,
                                      title: 'Completed date (Calculated)'
                                    }
                                  }
                                }
                              }
                            },
                            {
                              properties: {
                                fullPlanningPermissionGranted: {
                                  enum: ['Yes']
                                }
                              }
                            },
                            {
                              properties: {
                                fullPlanningPermissionGranted: {
                                  enum: ['N/A']
                                }
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
                                      items: {
                                        type: 'object',
                                        properties: {
                                          baselineCompletion: {
                                            title: 'Baseline completion',
                                            type: 'string',
                                            format: 'date',
                                            sourceKey: %i[baseline_data infrastructures statutoryConsents consents targetDateToBeMet]
                                          },
                                          varianceAgainstBaseline: {
                                            hidden: true,
                                            title: 'Variance against baseline (Calculated)',
                                            type: 'integer',
                                            readonly: true
                                          },
                                          varianceAgainstLastReturn: {
                                            hidden: true,
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
                                            hidden: true,
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
                            },
                            {
                              properties: {
                                s106Requirement: {
                                  enum: ['No']
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
                      sourceKey: %i[baseline_data infrastructures landOwnership underControlOfLA],
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
                                          variance: true,
                                          properties: {
                                            # from landOwnership.toBeAquiredBy
                                            baseline: {
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
                                              hidden: true,
                                              title: 'Variance Against Last Return (Calculated)'
                                            },
                                            # To be calculated
                                            landAssemblyVarianceAgainstBaseReturn: {
                                              type: 'string',
                                              readonly: true,
                                              hidden: true,
                                              title: 'Variance Against Base Return (Calculated)'
                                            },
                                            status: {
                                              title: 'Status against last return?',
                                              type: 'string',
                                              enum: [
                                                'Completed',
                                                'On schedule',
                                                'Delayed'
                                              ],
                                              default: 'On schedule'
                                            },
                                            current: {
                                              type: 'string',
                                              format: 'date',
                                              title: 'Current Return'
                                            },
                                            reason: {
                                              type: 'string',
                                              title: 'Reason for Variance'
                                            },
                                            percentComplete: {
                                              type: 'integer',
                                              title: 'Percent complete'
                                            },
                                            completedDate: {
                                              type: 'string',
                                              format: 'date',
                                              readonly: true,
                                              hidden: true,
                                              title: 'On Completed date (Calculated)'
                                            }
                                          }
                                        }
                                      }
                                    },
                                    {
                                      properties: {
                                        landAcquisitionRequired: {
                                          enum: ['No']
                                        }
                                      }
                                    }
                                  ]
                                }
                              }
                            }
                          }
                        },
                        {
                          properties: {
                            laHasControlOfSite: {
                              enum: ['Yes']
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
                    contractorProcured: {
                      type: 'string',
                      title: 'Infrastructure contractor procured?',
                      sourceKey: %i[baseline_data infrastructures procurement contractorProcured],
                      readonly: true,
                      items: {
                        type: 'string',
                        enum: %w[Yes No]
                      }
                    }
                  },
                  dependencies: {
                    contractorProcured: {
                      oneOf: [
                        {
                          properties: {
                            contractorProcured: {
                              enum: ['Yes']
                            },
                            nameOfContractor: {
                              sourceKey: %i[baseline_data infrastructures procurement nameOfContractor],
                              type: 'string',
                              title: 'Name of Contractor',
                              readonly: true
                            }
                          }
                        },
                        {
                          properties: {
                            contractorProcured: {
                              enum: ['No']
                            },
                            summaryOfCriticalPath: {
                              sourceKey: %i[baseline_data infrastructures procurement summaryOfCriticalPath],
                              type: 'string',
                              title: 'Summary of Critical Procurement Path',
                              readonly: true,
                              extendedText: true
                            },
                            procurementBaselineCompletion: {
                              type: 'string',
                              format: 'date',
                              title: 'Target date of procuring',
                              sourceKey: %i[baseline_data infrastructures procurement targetDate],
                              readonly: true
                            },
                            procurementVarianceAgainstLastReturn: {
                              type: 'string',
                              readonly: true,
                              hidden: true,
                              title: 'Variance against last return (Calculated)'
                            },
                            procurementVarianceAgainstBaseline: {
                              type: 'string',
                              readonly: true,
                              hidden: true,
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
                                    'Completed',
                                    'On schedule',
                                    'Delayed'
                                  ],
                                  default: 'On schedule'
                                },
                                currentReturn: {
                                  type: 'string',
                                  format: 'date',
                                  title: 'Current expected date of Procurement'
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
                              hidden: true,
                              title: 'Completion Date (Calculated)'
                            },
                            procurementCompletedNameOfContractor: {
                              type: 'string',
                              readonly: true,
                              hidden: true,
                              title: 'Completion Name of Contractor (Calculated)'
                            }
                          }
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
                        milestone: true,
                        properties: {
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
                            hidden: true,
                            title: 'Variance against last return (Calculated)'
                          },
                          milestoneVarianceAgainstBaseline: {
                            type: 'string',
                            readonly: true,
                            hidden: true,
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
                            hidden: true,
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
                            hidden: true,
                            title: 'Variance against last return (Calculated)'
                          },
                          milestoneVarianceAgainstBaseline: {
                            type: 'string',
                            readonly: true,
                            hidden: true,
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
                            hidden: true,
                            title: 'On Completed date (Calculated)'
                          }
                        }
                      }
                    },
                    expectedInfrastructureStartOnSite: {
                      type: 'object',
                      title: 'Expected infrastructure start on site',
                      variance: true,
                      properties: {
                        baseline: {
                          # from milestones.expectedInfrastructureStart
                          sourceKey: %i[baseline_data infrastructures expectedInfrastructureStart targetDateOfAchievingStart],
                          type: 'string',
                          title: 'Baseline Start on site',
                          readonly: true
                        },
                        varianceAgainstLastReturn: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance against last return (Calculated)'
                        },
                        varianceAgainstBaseline: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance against baseline (Calculated)'
                        },
                        status: {
                          title: 'Status against last return?',
                          type: 'string',
                          enum: [
                            'Completed',
                            'On schedule',
                            'Delayed'
                          ],
                          default: 'On schedule'
                        },
                        current: {
                          type: 'string',
                          format: 'date',
                          title: 'Current Return'
                        },
                        reason: {
                          type: 'string',
                          title: 'Reason for variance'
                        },
                        percentComplete: {
                          type: 'integer',
                          title: 'Percent complete'
                        },
                        completedDate: {
                          type: 'string',
                          format: 'date',
                          title: 'Completed Date'
                        }
                      }
                    },
                    expectedCompletionDateOfInfra: {
                      type: 'object',
                      title: 'Expected Completion date of infra',
                      variance: true,
                      properties: {
                        baseline: {
                          # from milestones.expectedInfrastructureStart
                          sourceKey: %i[baseline_data infrastructures expectedInfrastructureCompletion targetDateOfAchievingCompletion],
                          type: 'string',
                          format: 'date',
                          title: 'Baseline date of Completion',
                          readonly: true
                        },
                        varianceAgainstLastReturn: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance against last return (Calculated)'
                        },
                        varianceAgainstBaseline: {
                          type: 'string',
                          readonly: true,
                          hidden: true,
                          title: 'Variance against baseline (Calculated)'
                        },
                        status: {
                          title: 'Status against last return?',
                          type: 'string',
                          enum: [
                            'Completed',
                            'On schedule',
                            'Delayed'
                          ],
                          default: 'On schedule'
                        },
                        current: {
                          type: 'string',
                          format: 'date',
                          title: 'Current Return'
                        },
                        reason: {
                          type: 'string',
                          title: 'Reason for variance'
                        },
                        percentComplete: {
                          type: 'integer',
                          title: 'Percent complete'
                        },
                        completedDate: {
                          type: 'string',
                          format: 'date',
                          title: 'Completed Date'
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
                        risk: true,
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
                            hidden: true,
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
                            hidden: true,
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
          fundingProfiles: {
            type: 'object',
            title: 'HIF Grant Expenditure',
            properties: {
              totalHIFGrant: {
                type: 'string',
                title: 'Total HIF Grant',
                readonly: true,
                sourceKey: %i[baseline_data summary hifFundingAmount]
              },
              fundingRequest: {
                type: 'array',
                title: 'Funding Request',
                items: {
                  type: 'object',
                  properties: {
                    period: {
                      title: 'Period',
                      type: 'string',
                      sourceKey: %i[baseline_data fundingProfiles period],
                      readonly: true
                    },
                    forecast: {
                      title: 'Forecast',
                      type: 'object',
                      horizontal: true,
                      properties: {
                        instalment1: {
                          title: '1st Quarter',
                          type: 'string',
                          sourceKey: %i[baseline_data fundingProfiles instalment1],
                          readonly: true
                        },
                        instalment2: {
                          title: '2nd Quarter',
                          type: 'string',
                          sourceKey: %i[baseline_data fundingProfiles instalment2],
                          readonly: true
                        },
                        instalment3: {
                          title: '3rd Quarter',
                          type: 'string',
                          sourceKey: %i[baseline_data fundingProfiles instalment3],
                          readonly: true
                        },
                        instalment4: {
                          title: '4th Quarter',
                          type: 'string',
                          sourceKey: %i[baseline_data fundingProfiles instalment4],
                          readonly: true
                        },
                        total: {
                          title: 'Total',
                          type: 'string',
                          sourceKey: %i[baseline_data fundingProfiles total],
                          readonly: true
                        }
                      }
                    }
                  }
                }
              },
              changeRequired: {
                type: 'string',
                title: 'Change Required?',
                description: 'Please confirm there are no changes to be made to the funding profile',
                enum: ['Confirmed', 'Change required']
              }
            },
            dependencies: {
              changeRequired: {
                oneOf: [
                  {
                    properties: {
                      changeRequired: {
                        enum: ['Change required']
                      },
                      reasonForRequest: {
                        type: 'string',
                        title: 'Reason for request',
                        description: 'Changes to funding profile will need to be agreed by s.151 officer - you will be asked to agree to this on submission.'
                      },
                      mitigationInPlace: {
                        type: 'string',
                        title: 'Mitigation in place to reduce further slippage'
                      },
                      requestedProfiles: {
                        type: 'array',
                        title: 'Funding Request',
                        items: {
                          type: 'object',
                          properties: {
                            period: {
                              title: 'Period',
                              type: 'string',
                              sourceKey: %i[baseline_data fundingProfiles period],
                              readonly: true
                            },
                            newProfile: {
                              title: 'New Profile',
                              type: 'object',
                              horizontal: true,
                              properties: {
                                instalment1: {
                                  title: '1st Quarter',
                                  type: 'string'
                                },
                                instalment2: {
                                  title: '2nd Quarter',
                                  type: 'string'
                                },
                                instalment3: {
                                  title: '3rd Quarter',
                                  type: 'string'
                                },
                                instalment4: {
                                  title: '4th Quarter',
                                  type: 'string'
                                },
                                total: {
                                  title: 'Total',
                                  type: 'string'
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  },
                  {
                    properties: {
                      changeRequired: {
                        enum: ['Confirmed']
                      }
                    }
                  }
                ]
              }
            }
          },
          fundingPackages: {
            type: 'array',
            title: 'Funding Packages',
            items: {
              type: 'object',
              title: 'Funding for Infrastructure',
              properties: {
                fundingStack: {
                  type: 'object',
                  title: 'Funding stack',
                  properties: {
                    hifSpend: {
                      title: 'HIF Spend',
                      type: 'object',
                      horizontal: true,
                      properties: {
                        baseline: {
                          type: 'string',
                          title: 'HIF Baseline Amount',
                          sourceKey: %i[baseline_data costs infrastructure HIFAmount],
                          readonly: true
                        },
                        current: {
                          type: 'string',
                          title: 'Current Return'
                        },
                        lastReturn: {
                          type: 'string',
                          title: 'Last Return',
                          readonly: true,
                          sourceKey: %i[return_data fundingPackages hifSpend current]
                        }
                      }
                    },
                    totalCost: {
                      title: 'Total Cost',
                      type: 'object',
                      horizontal: true,
                      properties: {
                        baseline: {
                          type: 'string',
                          title: 'Baseline Amount',
                          sourceKey: %i[baseline_data costs infrastructure totalCostOfInfrastructure],
                          readonly: true
                        },
                        current: {
                          type: 'string',
                          title: 'Current return'
                        },
                        varianceReason: {
                          type: 'string',
                          title: 'Reason for variance'
                        },
                        percentComplete: {
                          type: 'integer',
                          title: 'Percent complete'
                        }
                      }
                    },
                    fundedThroughHIF: {
                      type: 'string',
                      title: 'Totally funded through HIF?',
                      enum: %w[Yes No],
                      readonly: true,
                      sourceKey: %i[baseline_data costs infrastructure totallyFundedThroughHIF]
                    }
                  },
                  dependencies: {
                    fundedThroughHIF: {
                      oneOf: [
                        {
                          properties: {
                            fundedThroughHIF: {
                              enum: ['Yes']
                            }
                          }
                        },
                        {
                          properties: {
                            fundedThroughHIF: {
                              enum: ['No']
                            },
                            descriptionOfFundingStack: {
                              type: 'string',
                              title: 'Description of funding stack',
                              readonly: true,
                              sourceKey: %i[baseline_data costs infrastructure descriptionOfFundingStack]
                            },
                            riskToFundingPackage: {
                              type: 'object',
                              horizontal: true,
                              title: 'Risk to funding package',
                              properties: {
                                risk: {
                                  title: 'Is there a risk?',
                                  type: 'string',
                                  enum: %w[Yes No]
                                },
                                description: {
                                  title: 'Description of risk',
                                  type: 'string'
                                }
                              }
                            },
                            public: {
                              title: 'Total Public',
                              type: 'object',
                              horizontal: true,
                              properties: {
                                baseline: {
                                  title: 'Total baseline amount',
                                  type: 'string',
                                  readonly: true,
                                  sourceKey: %i[baseline_data costs infrastructure totalPublic]
                                },
                                current: {
                                  title: 'Total - Current return',
                                  type: 'string'
                                },
                                reason: {
                                  title: 'Reason for variance',
                                  type: 'string'
                                },
                                amountSecured: {
                                  title: 'Amount secured to date',
                                  type: 'string'
                                }
                              }
                            },
                            private: {
                              title: 'Total Private',
                              type: 'object',
                              horizontal: true,
                              properties: {
                                baseline: {
                                  title: 'Total baseline amount',
                                  type: 'string',
                                  readonly: true,
                                  sourceKey: %i[baseline_data costs infrastructure totalPrivate]
                                },
                                current: {
                                  title: 'Total - Current return',
                                  type: 'string'
                                },
                                reason: {
                                  title: 'Reason for variance',
                                  type: 'string'
                                },
                                amountSecured: {
                                  title: 'Amount secured to date',
                                  type: 'string'
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
          }
        }
      }
    end

    return return_template if ENV['OUTPUTS_FORECAST_TAB'].nil?

    return_template.schema[:properties][:outputsForecast] = {
      title: 'Outputs - Forecast',
      type: 'object',
      properties: {
        summary: {
          type: 'object',
          title: 'Summary',
          properties: {
            totalUnits: {
              type: 'integer',
              title: 'Total Units',
              readonly: true,
              sourceKey: %i[baseline_data outputsForecast totalUnits]
            },
            disposalStrategy: {
              type: 'string',
              title: 'Disposal Strategy/Critical Path',
              readonly: true,
              sourceKey: %i[baseline_data outputsForecast disposalStrategy]
            }
          }
        },
        housingStarts: {
          type: 'object',
          title: 'Housing Starts',
          properties: {
            baselineAmounts: {
              title: 'Baseline Amounts',
              type: 'array',
              periods: true,
              items: {
                type: 'object',
                properties: {
                  period: {
                    type: 'string',
                    title: 'Period',
                    readonly: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast period]
                  },
                  baselineAmounts: {
                    type: 'string',
                    title: 'Baseline Amounts',
                    readonly: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast target]
                  }
                }
              }
            },
            anyChanges: {
              title: 'Any changes to baseline amounts?',
              type: 'string',
              enum: %w[Yes No]
            }
          },
          dependencies: {
            anyChanges: {
              oneOf: [
                {
                  properties: {
                    anyChanges: { enum: ['Yes'] },
                    currentReturnAmounts: {
                      type: 'array',
                      periods: true,
                      title: 'Current Return Amounts',
                      items: {
                        type: 'object',
                        properties: {
                          period: {
                            type: 'string',
                            title: 'Period',
                            readonly: true,
                            sourceKey: %i[baseline_data outputsForecast housingForecast period]
                          },
                          currentReturnForecast: {
                            type: 'string',
                            title: 'Current Return Forecast'
                          }
                        }
                      }
                    }
                  }
                },
                {
                  properties: {
                    anyChanges: { enum: ['No'] }
                  }
                }
              ]
            }
          }
        },
        inYearHousingStarts: {
          type: 'object',
          title: 'In year housing starts',
          properties: {
            risksToAchieving: {
              type: 'string',
              title: 'Risks to achieving'
            }
          }
        },
        housingCompletions: {
          type: 'object',
          title: 'Housing Completions',
          properties: {
            baselineAmounts: {
              title: 'Baseline Amounts',
              periods: true,
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  period: {
                    type: 'string',
                    title: 'Period',
                    readonly: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast period]
                  },
                  baselineAmounts: {
                    type: 'string',
                    title: 'Baseline Amounts',
                    readonly: true,
                    sourceKey: %i[baseline_data outputsForecast housingForecast housingCompletions]
                  }
                }
              }
            },
            anyChanges: {
              title: 'Any changes to baseline amounts?',
              type: 'string',
              enum: %w[Yes No]
            }
          },
          dependencies: {
            anyChanges: {
              oneOf: [
                {
                  properties: {
                    anyChanges: { enum: ['Yes'] },
                    currentReturnAmounts: {
                      type: 'array',
                      periods: true,
                      title: 'Current Return Amounts',
                      items: {
                        type: 'object',
                        properties: {
                          period: {
                            type: 'string',
                            title: 'Period',
                            readonly: true,
                            sourceKey: %i[baseline_data outputsForecast housingForecast period]
                          },
                          currentReturnForecast: {
                            type: 'string',
                            title: 'Current Return Forecast'
                          }
                        }
                      }
                    }
                  }
                },
                {
                  properties: {
                    anyChanges: { enum: ['No'] }
                  }
                }
              ]
            }
          }
        },
        inYearHousingCompletions: {
          type: 'object',
          title: 'In year housing completions',
          properties: {
            risksToAchieving: {
              type: 'string',
              title: 'Risks to achieving'
            }
          }
        }
      }
    }

    return_template.schema[:properties][:outputActuals] = {
      type: 'array',
      title: 'Output - Actuals',
      items: {
        title: 'Site',
        type: 'object',
        properties: {
          localAuthority: {
            type: 'string',
            title: 'Local Authority',
            readonly: true,
            sourceKey: %i[baseline_data outputsActuals siteOutputs siteLocalAuthority]
          },
          noOfUnits: {
            type: 'string',
            title: 'No. of Units',
            readonly: true,
            sourceKey: %i[baseline_data outputsActuals siteOutputs siteNumberOfUnits]
          },
          size: {
            type: 'string',
            title: 'Size (hectares)'
          },
          previousStarts: {
            type: 'string',
            title: 'Previous Starts',
            # hidden: true,
            readonly: true
          },
          startsSinceLastReturn: {
            type: 'string',
            title: 'Starts since last return'
          },
          previousCompletions: {
            type: 'string',
            title: 'Previous Completions',
            # hidden: 'true',
            readonly: 'true'
          },
          completionsSinceLastReturn: {
            type: 'string',
            title: 'Completions since last return'
          },
          laOwned: {
            type: 'string',
            title: 'Local Authority owned land?',
            enum: [
              'Yes',
              'No'
            ]
          },
          pslLand: {
            type: 'string',
            title: 'PSL Land?',
            enum: [
              'Yes',
              'No'
            ]
          },
          brownfieldPercent: {
            type: 'string',
            title: 'Brownfield %'
          },
          leaseholdPercent: {
            type: 'string',
            title: 'Leasehold %'
          },
          smePercent: {
            type: 'string',
            title: 'SME %'
          },
          mmcPercent: {
            type: 'string',
            title: 'MMC %'
          }
        }
      }
    }

    return_template
  end

  private

  def status_against_last_return
    {
      title: 'Status against last return?',
      type: 'string',
      enum: [
        'Completed',
        'On schedule',
        'Delayed'
      ],
      default: 'On schedule'
    }
  end
end
