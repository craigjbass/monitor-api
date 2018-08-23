# frozen_string_literal: true

# noinspection RubyScope
class LocalAuthority::Gateway::InMemoryReturnTemplate

  def find_by(type:)
    return nil unless type == 'hif'
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {
        '$schema': 'http://json-schema.org/draft-07/schema',
        title: 'HIF Project',
        type: 'object',
        properties: {
          infrastructures: {
            type: 'array',
            title: 'Infrastructures',
            items: {
              type: 'object',
              properties: {
                type: {
                  type: 'string',
                  # This is marked as a dropdown but also from baseline?
                  title: 'Type',
                  sourceKey: [:baseline_data, :infrastructures, :type]
                },
                description: {
                  type: 'string',
                  title: 'Description',
                  sourceKey: [:baseline_data, :infrastructures, :description]
                },
                planning: {
                  type: 'object',
                  title: 'Planning',
                  properties: {
                    # Baseline
                    # from outlinePlanningStatus.granted
                    baselineOutlinePlanningPermissionGranted: {
                      type: 'boolean',
                      title: 'Outline Planning Permission granted',
                      sourceKey: [:baseline_data, :infrastructures, :outlinePlanningStatus, :granted]
                    },
                    planningNotGranted: {
                      type: 'object',
                      title: 'Planning Not Granted',
                      properties: {
                        # from outlinePlanningStatus.summaryOfCriticalPathInfrastructures
                        baselineSummaryOfCriticalPath: {
                          type: 'string',
                          title: 'Summary Of Outline Planning Permission Critical Path',
                          sourceKey: [:baseline_data, :infrastructures, :outlinePlanningStatus, :summaryOfCriticalPath]
                        },
                        fieldOne: {
                          type: 'object',
                          title: 'Planning Not Granted Field One',
                          properties: {
                            baselineCompletion: {
                              type: 'object',
                              title: 'Baseline Completion',
                              properties: {
                                # Full planning submitted date
                                # fullPlanningStatus.targetSubmission
                                baselineFullPlanningPermissionSubmitted: {
                                  type: 'string',
                                  format: 'date',
                                  title: 'Full Planning Permission submitted date',
                                  sourceKey: [:baseline_data, :infrastructures, :fullPlanningStatus, :targetSubmission]
                                },
                                # Full planning granted date
                                # fullPlanningStatus.targetGranted
                                baselineFullPlanningPermissionGranted: {
                                  type: 'string',
                                  format: 'date',
                                  title: 'Full Planning Permission granted date',
                                  sourceKey: [:baseline_data, :infrastructures, :fullPlanningStatus, :targetGranted]
                                }
                              }
                            },
                            varianceCalculations: {
                              type: 'object',
                              title: 'Variance Calculations',
                              properties: {
                                varianceAgainstLastReturn: {
                                  type: 'object',
                                  title: 'Variance against Last Return',
                                  properties: {
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Last Return submitted date (Week)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Last Return granted date (Weeks)'
                                    }
                                  }
                                },
                                varianceAgainstBaseline: {
                                  type: 'object',
                                  title: 'Variance against Baseline',
                                  properties: {
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Baseline submitted date (Week)'
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Baseline granted date (Weeks)'
                                    }
                                  }
                                }
                              }
                            },
                            returnInput: {
                              type: 'object',
                              title: 'Return Input',
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
                            onCompleted: {
                              type: 'object',
                              title: 'On Completed',
                              properties: {
                                onCompletedDate: {
                                  type: 'string',
                                  format: 'date',
                                  readonly: true,
                                  title: 'TO BE GENERATED - On Completed date'
                                },
                                onCompletedReference: {
                                  type: 'string',
                                  readonly: true,
                                  title: 'TO BE GENERATED - On Completed Reference'
                                }
                              }
                            },
                            # from fullPlanningStatus.granted
                            fullPlanningPermissionGranted: {
                              type: 'boolean',
                              title: 'Full Planning Permission granted',
                              sourceKey: [:baseline_data, :infrastructures, :fullPlanningStatus, :granted]
                            },
                            # from fullPlanningStatus.summaryOfCriticalPath
                            fullPlanningPermissionSummaryOfCriticalPath: {
                              type: 'string',
                              title: 'Summary Of Full Planning Permission Critical Path',
                              sourceKey: [:baseline_data, :infrastructures, :fullPlanningStatus, :summaryOfCriticalPath]
                            }
                          }
                        },
                        fieldTwo: {
                          type: 'object',
                          title: 'Planning Not Granted Field Two',
                          properties: {
                            baselineCompletion: {
                              type: 'object',
                              title: 'Baseline Completion',
                              properties: {
                                # Full planning submitted date
                                # fullPlanningStatus.targetSubmission
                                baselineFullPlanningPermissionSubmitted: {
                                  type: 'string',
                                  format: 'date',
                                  title: 'Full Planning Permission submitted date',
                                  sourceKey: [:baseline_data, :infrastructures, :fullPlanningStatus, :targetSubmission]
                                },
                                # Full planning granted date
                                # fullPlanningStatus.targetGranted
                                baselineFullPlanningPermissionGranted: {
                                  type: 'string',
                                  format: 'date',
                                  title: 'Full Planning Permission granted date',
                                  sourceKey: [:baseline_data, :infrastructures, :fullPlanningStatus, :targetGranted]
                                }
                              }
                            },
                            varianceCalculations: {
                              type: 'object',
                              title: 'Variance Calculations',
                              properties: {
                                varianceAgainstLastReturn: {
                                  type: 'object',
                                  title: 'Variance against Last Return',
                                  properties: {
                                    varianceLastReturnFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Last Return submitted date (Week)'
                                    },
                                    varianceLastReturnFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Last Return granted date (Weeks)'
                                    }
                                  }
                                },
                                varianceAgainstBaseline: {
                                  type: 'object',
                                  title: 'Variance against Baseline',
                                  properties: {
                                    varianceBaselineFullPlanningPermissionSubmitted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Baseline submitted date (Week)'
                                    },
                                    varianceBaselineFullPlanningPermissionGranted: {
                                      type: 'integer',
                                      readonly: true,
                                      title: 'TO BE CALCULATED - Variance against Baseline granted date (Weeks)'
                                    }
                                  }
                                }
                              }
                            },
                            returnInput: {
                              type: 'object',
                              title: 'Return Input',
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
                            onCompleted: {
                              type: 'object',
                              title: 'On Completed',
                              properties: {
                                onCompletedDate: {
                                  type: 'string',
                                  format: 'date',
                                  readonly: true,
                                  title: 'TO BE GENERATED - On Completed date'
                                },
                                onCompletedReference: {
                                  type: 'string',
                                  readonly: true,
                                  title: 'TO BE GENERATED - On Completed Reference'
                                }
                              }
                            }
                          }
                        },
                        # from s106.requirement
                        s106Requirement: {
                          type: 'boolean',
                          title: 'S016 Requirement',
                          sourceKey: [:baseline_data, :infrastructures, :s106, :requirement]
                        },
                        # from s106.summaryOfRequirement
                        s106SummaryOfRequirement: {
                          type: 'string',
                          title: 'Summary of S016 Requirement ',
                          sourceKey: [:baseline_data, :infrastructures, :s106, :summaryOfRequirement]
                        },
                        # from statutoryConsents.anyConsents
                        statutoryConsents: {
                          type: 'object',
                          title: 'Statutory Consents',
                          properties: {
                            anyStatutoryConsents: {
                              type: 'boolean',
                              title: 'Statutory consents to be met?',
                              sourceKey: [:baseline_data, :infrastructures, :statutoryConsents, :anyConsents]
                            }
                          }
                        }
                      }
                    },
                    planningGranted: {
                      type: 'object',
                      title: 'Planning Granted',
                      properties: {
                        risksToAchievingTimeScales: {
                          type: 'array',
                          title: 'Risks to achieving timescales',
                          items: {
                            type: 'object',
                            properties: {
                              planningGrantedBaselineCompletion: {
                                type: 'object',
                                title: 'Planning Granted Baseline Completion',
                                properties: {
                                  # Full planning submitted date
                                  # fullPlanningStatus.targetSubmission
                                  baselineFullPlanningPermissionSubmitted: {
                                    type: 'string',
                                    format: 'date',
                                    title: 'Full Planning Permission submitted date'
                                  },
                                  # Full planning granted date
                                  # fullPlanningStatus.targetGranted
                                  baselineFullPlanningPermissionGranted: {
                                    type: 'string',
                                    format: 'date',
                                    title: 'Full Planning Permission granted date'
                                  }
                                }
                              },
                              planningGrantedVarianceCalculations: {
                                type: 'object',
                                title: 'Planning Granted Variance Calculations',
                                properties: {
                                  varianceAgainstLastReturn: {
                                    type: 'object',
                                    title: 'Variance against Last Return',
                                    properties: {
                                      varianceLastReturnFullPlanningPermissionSubmitted: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Last Return submitted date (Week)'
                                      },
                                      varianceLastReturnFullPlanningPermissionGranted: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Last Return granted date (Weeks)'
                                      }
                                    }
                                  },
                                  varianceAgainstBaseline: {
                                    type: 'object',
                                    title: 'Variance against Baseline',
                                    properties: {
                                      varianceBaselineFullPlanningPermissionSubmitted: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Baseline submitted date (Week)'
                                      },
                                      varianceBaselineFullPlanningPermissionGranted: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Baseline granted date (Weeks)'
                                      }
                                    }
                                  }
                                }
                              },
                              planningGrantedReturnInput: {
                                type: 'object',
                                title: 'Planning Granted Return Input',
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
                              planningGrantedOnCompletd: {
                                type: 'object',
                                title: 'Planning Granted On Completed',
                                properties: {
                                  onCompletedDate: {
                                    type: 'string',
                                    format: 'date',
                                    readonly: true,
                                    title: 'TO BE GENERATED - On Completed date'
                                  },
                                  onCompletedReference: {
                                    type: 'string',
                                    readonly: true,
                                    title: 'TO BE GENERATED - On Completed Reference'
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
                landOwnership: {
                  type: 'object',
                  title: 'Land Ownership',
                  properties: {
                    # from landOwnership.underControlOfLA
                    laHasControlOfSite: {
                      type: 'boolean',
                      title: 'LA Control of site(s) (related to infrastructure)? ',
                      sourceKey: [:baseline_data, :infrastructures, :landOwnership, :landAcquisitionRequired]
                    },
                    laDoesNotControlSite: {
                      type: 'object',
                      title: 'LA Does Not Have Control Of Site',
                      properties: {
                        # from  landOwnership.ownershipOfLandOtherThanLA
                        whoOwnsSite: {
                          type: 'string',
                          title: 'Who owns site?',
                          sourceKey: [:baseline_data, :infrastructures, :landOwnership, :ownershipOfLandOtherThanLA]
                        },
                        # from landOwnership.landAcquisitionRequired
                        landAquisitionRequired: {
                          type: 'boolean',
                          title: 'Land acquisition required (related to infrastructure)?',
                          sourceKey: [:baseline_data, :infrastructures, :landOwnership, :landAcquisitionRequired]
                        }
                      }
                    },
                    laDoesHaveControlOfSite: {
                      type: 'object',
                      title: 'LA Does Have Control Of Site',
                      properties: {
                        # from landOwnership.howManySitesToAquire
                        howManySitesToAquire: {
                          type: 'integer',
                          title: 'Number of Sites to aquire?',
                          sourceKey: [:baseline_data, :infrastructures, :landOwnership, :howManySitesToAcquire]
                        },
                        # from landOwnership.toBeAquiredBy
                        toBeAquiredBy: {
                          type: 'string',
                          title: 'Acquired by LA or Developer?',
                          sourceKey: [:baseline_data, :infrastructures, :landOwnership, :toBeAcquiredBy]
                        },
                        # from landOwnership.summaryOfCriticalPath
                        summaryOfAcquisitionRequired: {
                          type: 'string',
                          title: 'Summary of acquisition required',
                          sourceKey: [:baseline_data, :infrastructures, :landOwnership, :summaryOfCriticalPath]
                        },
                        allLandAssemblyAchieved: {
                          type: 'object',
                          title: 'All land assembly achieved',
                          properties: {
                            # from landOwnership.toBeAquiredBy
                            landAssemblyBaselineCompletion: {
                              type: 'string',
                              format: 'date',
                              title: 'Baseline Completion',
                              sourceKey: [:baseline_data, :infrastructures, :landOwnership, :targetDateToAcquire]
                            },
                            # To be calculated
                            landAssemblyVarianceAgainstLastReturn: {
                              type: 'string',
                              readonly: true,
                              title: 'TO BE CALCULATED - Variance Against Last Return'
                            },
                            # To be calculated
                            landAssemblyVarianceAgainstBaseReturn: {
                              type: 'string',
                              readonly: true,
                              title: 'TO BE CALCULATED - Variance Against Base Return'
                            },
                            landAssemblyStatusAgainstLastReturn: {
                              title: 'Land Assembly Status Against Last Return',
                              type: 'object',
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
                            landAssemblyCompletedDate: {
                              type: 'string',
                              format: 'date',
                              readonly: true,
                              title: 'TO BE GENERATED - On Completed date'
                            }
                          }
                        }
                      }
                    }
                  }
                },
                procurement: {
                  type: 'object',
                  title: 'Procurement',
                  properties: {
                    # from procurement.contractorProcured
                    contractorProcured: {
                      type: 'boolean',
                      title: 'Infrastructure contractor procured?',
                      sourceKey: [:baseline_data, :infrastructures, :landOwnership, :procurement, :contractorProcured]
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
                              sourceKey: [:baseline_data, :infrastructures, :landOwnership,  :procurement, :targetDateToAquire]
                            },
                            procurementVarianceAgainstLastReturn: {
                              type: 'string',
                              readonly: true,
                              title: 'TO BE CALCULATED - Variance against last return'
                            },
                            procurementVarianceAgainstBaseline: {
                              type: 'string',
                              readonly: true,
                              title: 'TO BE CALCULATED - Variance against baseline'
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
                              title: 'TO BE GENERATED - Completion Date'
                            },
                            procurementCompletedNameOfContractor: {
                              type: 'string',
                              readonly: true,
                              title: 'TO BE GENERATED - Completion Name of Contractor'
                            }
                          },
                          # from procurement.summaryOfCriticalPath
                          summaryOfCriticalPath: {
                            sourceKey: [:baseline_data, :infrastructures, :landOwnership,:procurement, :summaryOfCriticalPath],
                            type: 'string',
                            title: 'Summary of Critical Procurement Path'
                          }
                        }
                      }
                    },
                    infrastructureProcured: {
                      type: 'object',
                      title: 'Infrastructure procured',
                      properties: {
                        # from procurement.nameOfContractor
                        nameOfContractor: {
                          sourceKey: [:baseline_data, :infrastructures, :landOwnership,:procurement, :nameOfContractor],
                          type: 'string',
                          title: 'Name of Contractor'
                        }
                      }
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
                        properties: {
                          # from milestones.target
                          milestoneBaselineCompletion: {
                            sourceKey: [:baseline_data, :infrastructures, :milestones, :target],
                            type: 'string',
                            format: 'date',
                            title: 'Baseline Completion '
                          },
                          # from milestones.summaryOfCriticalPath
                          milestoneSummaryOfCriticalPath: {
                            sourceKey: [:baseline_data, :infrastructures, :milestones, :summaryOfCriticalPath],
                            type: 'string',
                            title: 'Summary of Baseline Critical Path'
                          },
                          milestoneVarianceAgainstLastReturn: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Variance against last return'
                          },
                          milestoneVarianceAgainstBaseline: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Variance against baseline'
                          },
                          milestoneStatusAgainstLastReturn: {
                            type: 'object',
                            title: 'Milestone Status Against Last Return',
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
                          milestonePercentCompleted: {
                            type: 'integer',
                            title: 'Percent complete'
                          },
                          milestoneCompletedDate: {
                            type: 'string',
                            format: 'date',
                            readonly: true,
                            title: 'TO BE GENERATED - On Completed date'
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
                          sourceKey: [:baseline_data, :infrastructures, :expectedInfrastructureStart, :targetDateOfAchievingStart],
                          type: 'string',
                          title: 'Baseline Start on site'
                        },
                        milestoneExpectedInfrastructureStartVarianceAgaistLastReturn: {
                          type: 'string',
                          readonly: true,
                          title: 'TO BE CALCULATED - Variance against last return'
                        },
                        milestoneExpectedInfrastructureStartVarianceAgaistBaseline: {
                          type: 'string',
                          readonly: true,
                          title: 'TO BE CALCULATED - Variance against baseline'
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
                          title: 'TO BE GENERATED - On Completed date'
                        }
                      }
                    },
                    expectedCompletionDateOfInfra: {
                      type: 'object',
                      title: 'Expected Completion date of infra',
                      properties: {
                        milestoneExpectedInfrastructureCompletionBaseline: {
                          # from milestones.expectedInfrastructureCompletion
                          sourceKey: [:baseline_data, :infrastructures, :expectedInfrastructureCompletion, :targetDateOfAchievingCompletion],
                          type: 'string',
                          title: 'Baseline Completion'
                        },
                        milestoneExpectedInfrastructureCompletionVarianceAgaistLastReturn: {
                          type: 'string',
                          readonly: true,
                          title: 'TO BE CALCULATED - Variance against last return'
                        },
                        milestoneExpectedInfrastructureCompletionVarianceAgaistBaseline: {
                          type: 'string',
                          readonly: true,
                          title: 'TO BE CALCULATED - Variance against baseline'
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
                          title: 'TO BE GENERATED - On Completed date'
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
                      type: 'object',
                      title: 'Baseline Risks',
                      properties: {
                        risks: {
                          type: 'array',
                          title: 'Risks',
                          items: {
                            type: 'object',
                            properties: {
                              items: {
                                title: 'Risk',
                                type: 'object',
                                properties: {
                                  # from risksToAchievingTimescales.descriptionOfRisk
                                  riskBaselineRisk: {
                                  sourceKey: [:baseline_data, :infrastructures, :risksToAchievingTimescales, :descriptionOfRisk],
                                    type: 'string',
                                    title: 'Description Of Risk'
                                  },
                                  # from risksToAchievingTimescales.impactOfRisk
                                  riskBaselineImpact: {
                                    sourceKey: [:baseline_data, :infrastructures, :risksToAchievingTimescales, :impactOfRisk],
                                    type: 'string',
                                    title: 'Impact'
                                  },
                                  # from risksToAchievingTimescales.likelihoodOfRisk
                                  riskBaselineLikelihood: {
                                    sourceKey: [:baseline_data, :infrastructures, :risksToAchievingTimescales, :likelihoodOfRisk],
                                    type: 'string',
                                    title: 'Likelihood'
                                  },
                                  riskCurrentReturnLikelihood: {
                                    type: 'string',
                                    title: 'Current Return Likelihood'
                                  },
                                  # from risksToAchievingTimescales.mitigationOfRisk
                                  riskBaselineMitigationsInPlace: {
                                    sourceKey: [:baseline_data, :infrastructures, :risksToAchievingTimescales, :mitigationOfRisk],
                                    type: 'string',
                                    title: 'Mitigation in place'
                                  },
                                  riskAnyChange: {
                                    type: 'boolean',
                                    title: 'Any change in risk?'
                                  },
                                  riskCurrentReturnMitigationsInPlace: {
                                    type: 'string',
                                    title: 'Current Return Mitigations in place'
                                  },
                                  riskMetDate: {
                                    type: 'string',
                                    format: 'date',
                                    readonly: true,
                                    title: 'TO BE GENERATED - Risk met date'
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    additionalRisks: {
                      type: 'object',
                      title: 'Any additional risks to baseline?',
                      properties: {
                        currentRisks: {
                          type: 'array',
                          title: 'Current Risks',
                          items: {
                            type: 'object',
                            title: 'Risk',
                            properties: {
                              currentRisksToBaseline: {
                                type: 'object',
                                title: 'Current Risks to baseline',
                                properties: {
                                  newRisk: {
                                    type: 'string',
                                    title: 'New risk description'
                                  },
                                  newRiskImpact: {
                                    type: 'string',
                                    title: 'Impact'
                                  },
                                  newRiskLikelihood: {
                                    type: 'string',
                                    title: 'Likelihood'
                                  },
                                  newRiskMitigationsInPlace: {
                                    type: 'string',
                                    title: 'Mitigations in place'
                                  }
                                }
                              }
                            }
                          }
                        },
                        previousRisks: {
                          type: 'array',
                          title: 'Previous Risks',
                          items: {
                            type: 'object',
                            properties: {
                              previousRisksToBaseline: {
                                type: 'object',
                                title: 'Previous Risks to baseline',
                                properties: {
                                  previousRisk: {
                                    type: 'string',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Previous risk description'
                                  },
                                  previousRiskImpact: {
                                    type: 'string',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Previous risk impact'
                                  },
                                  previousRiskLikelihood: {
                                    type: 'string',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Previous risk likelihood'
                                  },
                                  previousRiskCurrentReturnLikelihood: {
                                    type: 'string',
                                    title: 'Current Return Likelihood'
                                  },
                                  previousRiskMitigationsInPlace: {
                                    type: 'string',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Previous Mitigations in place'
                                  },
                                  previousRiskAnyChanges: {
                                    type: 'boolean',
                                    title: 'Any Change?'
                                  },
                                  previousRiskCurrentReturnMitigationsInPlace: {
                                    type: 'string',
                                    title: 'Current Return Mitigations in place'
                                  },
                                  previousRiskMetDate: {
                                    type: 'string',
                                    format: 'date',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Risk Met Date'
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
                progress: {
                  type: 'object',
                  title: 'Progress',
                  properties: {
                    describeQuarterProgress: {
                      type: 'string',
                      title: 'Describe progress for last quarter'
                    },
                    progressAgainstActions: {
                      type: 'object',
                      title: 'Progress against Actions',
                      properties: {
                        liveActions: {
                          type: 'array',
                          title: 'Live Actions',
                          items: {
                            type: 'object',
                            properties: {
                              liveActionDescription: {
                                type: 'string',
                                readonly: true,
                                # from actions for next quarter
                                title: 'TO BE CALCULATED - Description of live action'
                              },
                              liveActionMet: {
                                type: 'boolean',
                                title: 'Action Met?'
                              },
                              liveActionProgress: {
                                type: 'string',
                                title: 'Progress against action if not met'
                              }
                            }
                          }
                        }
                      }
                    },
                    actionsForNextQuarter: {
                      type: 'array',
                      title: 'Actions for next quarter',
                      items: {
                        type: 'object',
                        properties: {
                          action: {
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
              type: 'object',
              properties: {
                hifFundingRequest: {
                  type: 'string',
                  # from s§151 (not done yet)
                  title: 'HIF Funding Request'
                },
                hifFundingProfile: {
                  type: 'array',
                  title: 'HIF Funding Profile',
                  items: {
                    type: 'object',
                    properties: {
                      fundingYear: {
                        type: 'string',
                        # from items.instalments.baselineInstalments.baselineInstalmentYear
                        title: 'Funding Year',
                        sourceKey: [:baseline_data, :financial, :instalments, :baselineInstalments, :baselineInstalmentYear]
                      },
                      forecast: {
                        type: 'object',
                        title: 'Forecast',
                        properties: {
                          forecastQ1: {
                            type: 'string',
                            # from items.instalments.baselineInstalments.baselineInstalmentQ1
                            title: 'Forecast Q1',
                            sourceKey: [:baseline_data, :financial, :instalments, :baselineInstalments, :baselineInstalmentQ1]
                          },
                          forecastQ2: {
                            type: 'string',
                            # from items.instalments.baselineInstalments.baselineInstalmentQ2
                            title: 'Forecast Q2',
                            sourceKey: [:baseline_data, :financial, :instalments, :baselineInstalments, :baselineInstalmentQ2]
                          },
                          forecastQ3: {
                            type: 'string',
                            # from items.instalments.baselineInstalments.baselineInstalmentQ3
                            title: 'Forecast Q3',
                            sourceKey: [:baseline_data, :financial, :instalments, :baselineInstalments, :baselineInstalmentQ3]
                          },
                          forecastQ4: {
                            type: 'string',
                            # from items.instalments.baselineInstalments.baselineInstalmentQ4
                            title: 'Forecast Q4',
                            sourceKey: [:baseline_data, :financial, :instalments, :baselineInstalments, :baselineInstalmentQ4]
                          },
                          forecastTotal: {
                            type: 'string',
                            # from items.instalments.baselineInstalments.baselineInstalmentTotal
                            title: 'Forecast Total',
                            sourceKey: [:baseline_data, :financial, :instalments, :baselineInstalments, :baselineInstalmentTotal]
                          }
                        },
                      },
                      actual: {
                        type: 'object',
                        title: 'Actual',
                        properties: {
                          forecastQ1: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Actual Q1'
                          },
                          forecastQ2: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Actual Q2'
                          },
                          forecastQ3: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Actual Q3'
                          },
                          forecastQ4: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Actual Q4'
                          },
                          forecastTotal: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Actual Total'
                          }
                        }
                      }
                    }
                  },
                },
                hifConfirmNoChanges: {
                  type: 'boolean',
                  title: 'Please confirm there are no changes to be made to the funding profile'
                },
                hifIfFundingChangeRequested: {
                  type: 'string',
                  title: 'If change requested, reason for request'
                },
                hifRequestedProfile: {
                  type: 'array',
                  title: 'Requested profile',
                  items: {
                    type: 'object',
                    properties: {
                      fundingYear: {
                        type: 'string',
                        title: 'Requested Year'
                      },
                      changeInPeriod: {
                        type: 'boolean',
                        title: 'Change in Period'
                      },
                      newProfile: {
                        type: 'object',
                        title: 'New Profile',
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
                            title: 'TO BE CALCULATED - New Profile Total'
                          }
                        }
                      },
                      variance: {
                        type: 'object',
                        title: 'Variance',
                        properties: {
                          varianceQ1: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Variance Q1'
                          },
                          varianceQ2: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Variance Q2'
                          },
                          varianceQ3: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Variance Q3'
                          },
                          varianceQ4: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Variance Q4'
                          },
                          varianceTotal: {
                            type: 'string',
                            readonly: true,
                            title: 'TO BE CALCULATED - Variance Total'
                          }
                        }
                      }
                    }
                  }
                },
                changeInPeriod: {
                  type: 'string',
                  title: 'Mitigation in place to reduce further slippage'
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
                                properties: {
                                  # finances.costs.costOfInfrastructure
                                  baselineCost: {
                                    sourceKey: [:baseline_data, :financial, :costs, :costOfInfrastructure],
                                    type: 'integer',
                                    title: 'Cost of Infrastructure'
                                  },
                                  currentCostReturn: {
                                    type: 'integer',
                                    title: 'Current Cost Return'
                                  },
                                  lastCostReturn: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Last Cost Return'
                                  },
                                  varianceCostAgainstBaseline: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Variance against Baseline'
                                  },
                                  varianceCostAgainstLastReturn: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Variance against last Return'
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
                                    title: 'TO BE CALCULATED - Cost Final Amount'
                                  },
                                  costReasonForVariance: {
                                    type: 'string',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Reason for Variance'
                                  }
                                }
                              },
                              hifSpendSinceLastReturn: {
                                type: 'object',
                                title: 'HIF Spend since last return',
                                properties: {
                                  hifSpendCurrentReturn: {
                                    type: 'integer',
                                    title: 'Current HIF spend since last return'
                                  },
                                  hifSpendLastReturn: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Current HIF spend since last return',
                                    sourceKey: [:return_data, :funding, :fundingPackages, :fundingPackage, :overview, :hifSpendSinceLastReturn, :hifSpendCurrentReturn]
                                  },
                                  hifSpendVariance: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Current HIF spend variance'
                                  },
                                  hifSpendRemaining: {
                                    type: 'integer',
                                    readonly: true,
                                    title: 'TO BE CALCULATED - Current HIF spend remaining'
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
                                sourceKey: [:baseline_data, :financial, :costs, :fundingStack, :totallyFundedThroughHIF],
                                type: 'boolean',
                                title: 'Totally funded through HIF?'
                              },
                              # if totallFundedThroughHIF == false
                              notFundedThroughHif: {
                                type: 'object',
                                title: 'Not Funded Through HIF',
                                properties: {
                                  # from costs.fundingstack.descriptionOfFundingStack
                                  descriptionOfFundingStack: {
                                    sourceKey: [:baseline_data, :financial, :costs, :fundingStack, :descriptionOfFundingStack],
                                    type: 'string',
                                    title: 'Description of Funding Stack'
                                  },
                                  riskToFundingPackage: {
                                    type: 'boolean',
                                    title: 'Risk to funding package'
                                  },
                                  # if riskToFundingPackage = true
                                  riskToFundingPackageDescription: {
                                    type: 'string',
                                    title: 'Risk to funding package Description'
                                  },
                                  totalPublic: {
                                    type: 'object',
                                    title: 'Total Public',
                                    properties: {
                                      # from costs.fundingStack.totalPublic.
                                      publicTotalBaselineAmount: {
                                        sourceKey: [:baseline_data, :financial, :costs, :fundingStack, :totalPublic],
                                        type: 'integer',
                                        title: 'Total Public Baseline Amount'
                                      },
                                      publicTotalCurrentReturn: {
                                        type: 'integer',
                                        title: 'Total Public Current Amount'
                                      },
                                      publicTotalLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Total Last Return'
                                      },
                                      publicVarianceAgainstBaseline: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Baseline'
                                      },
                                      publicVarianceAgainstLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Last Return'
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
                                        title: 'TO BE CALCULATED - Secured against Baseline'
                                      },
                                      publicIncreaseOnLastReturnAmount: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Increase on Last Return Amount'
                                      },
                                      publicIncreaseOnLastReturnPercent: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Increase on Last Return Percent'
                                      },
                                      publicRemainingToBeSecured: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Remaining to be secured'
                                      }
                                    }
                                  },
                                  totalPrivate: {
                                    type: 'object',
                                    title: 'Total Private',
                                    properties: {
                                      # from costs.fundingStack.totalPrivate
                                      privateTotalBaselineAmount: {
                                        sourceKey: [:baseline_data, :financial, :costs, :fundingStack, :totalPrivate],
                                        type: 'integer',
                                        title: 'Total Private Baseline Amount'
                                      },
                                      privateTotalCurrentReturn: {
                                        type: 'integer',
                                        title: 'Total Private Current Amount'
                                      },
                                      privateTotalLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Total Last Return'
                                      },
                                      privateVarianceAgainstBaseline: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Baseline'
                                      },
                                      privateVarianceAgainstLastReturn: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Variance against Last Return'
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
                                        title: 'TO BE CALCULATED - Secured against Baseline'
                                      },
                                      privateIncreaseOnLastReturnAmount: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Increase on Last Return Amount'
                                      },
                                      privateIncreaseOnLastReturnPercent: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Increase on Last Return Percent'
                                      },
                                      privateRemainingToBeSecured: {
                                        type: 'integer',
                                        readonly: true,
                                        title: 'TO BE CALCULATED - Remaining to be secured'
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
                      sourceKey: [:baseline_data, :financial, :recovery, :aimToRecover],
                      type: 'boolean',
                      title: 'Aim to recover any funding?'
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
end
