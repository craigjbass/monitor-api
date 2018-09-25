# frozen_string_literal: true

class HomesEngland::Gateway::InMemoryTemplate
  def get_template(type:)
    return nil unless type == 'hif'
    hif_template = HomesEngland::Domain::Template.new
    hif_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'HIF Project',
      type: 'object',
      properties: {
        summary: hif_summary,
        infrastructures: hif_infrastructures,
        fundingProfiles: {
          type: 'array',
          title: 'Funding profiles',
          items: {
            type: 'object',
            title: 'Funding Profile',
            properties: {
              period: { type: 'string', title: 'Period' },
              instalment1: { type: 'string', title: '1st Instalment' },
              instalment2: { type: 'string', title: '2nd Instalment' },
              instalment3: { type: 'string', title: '3rd Instalment' },
              instalment4: { type: 'string', title: '4th Instalment' },
              total: { type: 'string', title: 'Total' },
            }
          }
        },
        costs: {
          type: 'array',
          title: 'Costs',
          items: {
            type: 'object',
            title: 'Cost',
            properties: {
              infrastructure: {
                type: 'object',
                title: 'Infrastructure',
                properties: {
                  HIFAmount: {
                    type: 'string',
                    title: 'Total HIF Amount'
                  },
                  totalCostOfInfrastructure: {
                    type: 'string',
                    title: 'Total Cost of Infrastructure'
                  },
                  totallyFundedThroughHIF: {
                    type: 'string',
                    title: 'Totally funded through HIF?',
                    enum: ['Yes', 'No']
                  },
                },
                dependencies: {
                  totallyFundedThroughHIF: {
                    oneOf: [
                      {
                        properties: {
                          totallyFundedThroughHIF: {
                            enum: ['Yes']
                          }
                        }
                      },
                      {
                        properties: {
                          totallyFundedThroughHIF: {
                            enum: ['No']
                          },
                          descriptionOfFundingStack: {
                            type: 'string',
                            title: 'If No: Description of Funding Stack'
                          },
                          totalPublic: {
                            type: 'string',
                            title: 'If No, Total Public (exc. HIF)'
                          },
                          totalPrivate: {
                            type: 'string',
                            title: 'If No, Total Private'
                          }
                        }
                      }
                    ]
                  }
                }
              }
            }
          }
        },
        s151: hif_s151,
        outputsForecast: outputs_forecast,
        outputsActuals: outputs_actuals
      }
    }

    hif_template.layout = {
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
          submission_estimated: nil
        }
      },
      financial: {
        total_amount_estimated: nil
      }
    }
    hif_template
  end

  def hif_finances
    {
      type: 'object',
      title: 'Financials',
      properties: {
        fundingProfile: {
          type: 'array',
          title: 'HIF Funding Profiles',
          items: {
            type: 'object',
            properties: {
              period: { type: 'string', title: 'Period' },
              instalment1: { type: 'string', title: '1st Instalment' },
              instalment2: { type: 'string', title: '2nd Instalment' },
              instalment3: { type: 'string', title: '3rd Instalment' },
              instalment4: { type: 'string', title: '4th Instalment' },
              total: { type: 'string', title: 'Total' },
            }
          }
        },
        costs: {
          type: 'array',
          title: 'Cost of Infrastructures',
          items: {
            type: 'object',
            properties: {
              costOfInfrastructure: {
                type: 'string',
                title: 'Cost of Infrastructure'
              },
              totalCostOfInfrastructure: {
                type: 'string',
                title: 'Total Cost of Infrastructure'
              },
              totallyFundedThroughHIF: {
                type: 'string',
                title: 'Totally funded through HIF?',
                enum: ['Yes', 'No']
              },
            },
            dependencies: {
              totallyFundedThroughHIF: {
                oneOf: [
                  {
                    properties: {
                      totallyFundedThroughHIF: {
                        enum: ['Yes']
                      }
                    }
                  },
                  {
                    properties: {
                      totallyFundedThroughHIF: {
                        enum: ['No']
                      },
                      descriptionOfFundingStack: {
                        type: 'string',
                        title: 'If No: Description of Funding Stack'
                      },
                      totalPublic: {
                        type: 'string',
                        title: 'If No, Total Public (exc. HIF)'
                      },
                      totalPrivate: {
                        type: 'string',
                        title: 'If No, Total Private'
                      }
                    }
                  }
                ]
              }
            }
          }
        },
        baselineCashflow: {
          type: 'object',
          title: 'Baseline Cashflow',
          properties: {
            summaryOfRequirement: {
              type: 'string',
              format: 'data-url',
              title: 'Baseline Cashflow'
            }
          }
        },
        recovery: {
          type: 'object',
          title: 'Recovery',
          properties: {
            aimToRecover: {
              type: 'string',
              title: 'Aim to Recover?',
              enum: ['Yes', 'No']
            },
          },
          dependencies: {
            aimToRecover: {
              oneOf: [
                {
                  properties: {
                    aimToRecover: {
                      enum: ['Yes']
                    },
                    expectedAmountToRecover: {
                      type: 'string',
                      title: 'Expected Amount'
                    },
                    methodOfRecovery: {
                      type: 'string',
                      title: 'Method of Recovery?'
                    }
                  }
                },
                {
                  properties: {
                    aimToRecover: {
                      enum: ['No']
                    }
                  }
                }
              ]
            }
          }
        }
      }
    }
  end

  def hif_infrastructures
    {
      type: 'array',
      title: 'Infrastructures',
      items: {
        title: 'Infrastructure',
        type: 'object',
        properties: {
          type: {
            type: 'string',
            title: 'Type'
          },
          description: {
            type: 'string',
            title: 'Description'
          },
          housingSitesBenefitting: {
            type: 'string',
            title: 'Housing Sites Benefitting'
          },
          outlinePlanningStatus: {
            type: 'object',
            title: 'Outline Planning Status',
            properties: {
              granted: {
                type: 'string',
                title: 'Granted?',
                enum: ['Yes', 'No', 'N/A']
              }
            },
            dependencies: {
              granted: {
                oneOf: [
                  {
                    properties: {
                      granted: {
                        enum: ['Yes']
                      },
                      reference: {
                        type: 'string',
                        title: 'Reference'
                      }
                    }
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['No']
                      },
                      targetSubmission: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of submission'
                      },
                      targetGranted: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of planning granted'
                      },
                      summaryOfCriticalPath: {
                        type: 'string',
                        title: 'Summary of Critical Path'
                      }
                    }
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['N/A']
                      }
                    }
                  }
                ]
              }
            }
          },
          fullPlanningStatus: {
            type: 'object',
            title: 'Full Planning Status',
            properties: {
              granted: {
                type: 'string',
                title: 'Granted?',
                enum: ['Yes', 'No', 'N/A']
              }
            },
            required: ['granted'],
            dependencies: {
              granted: {
                oneOf: [
                  {
                    properties: {
                      granted: {
                        enum: ['Yes']
                      },
                      reference: {
                        type: 'string',
                        title: 'Reference'
                      }
                    },
                    required: ['reference']
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['No']
                      },
                      targetSubmission: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of submission'
                      },
                      targetGranted: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of planning granted'
                      },
                      summaryOfCriticalPath: {
                        type: 'string',
                        title: 'Summary of Critical Path'
                      }
                    },
                    required: [
                      'targetSubmission', 'targetGranted', 'summaryOfCriticalPath'
                    ]
                  },
                  {
                    properties: {
                      granted: {
                        enum: ['N/A']
                      }
                    }
                  }
                ]
              }
            }
          },
          s106: {
            type: 'object',
            title: 'Section 106',
            properties: {
              requirement: {
                type: 'string',
                title: 'Is this a requirement?',
                enum: ['Yes', 'No']
              }
            },
            dependencies: {
              requirement: {
                oneOf: [
                  {
                    properties: {
                      requirement: {
                        enum: ['Yes']
                      },
                      summaryOfRequirement: {
                        type: 'string',
                        title: 'If Yes: Summary of requirement'
                      }
                    }
                  },
                  {
                    properties: {
                      requirement: {
                        enum: ['No']
                      }
                    }
                  }
                ]
              }
            }
          },
          statutoryConsents: {
            type: 'object',
            title: 'Statutory Consents',
            properties: {
              anyConsents: {
                type: 'string',
                title: 'Any Statutory Consents?',
                enum: ['Yes', 'No']
              }
            },
            required: ['anyConsents'],
            dependencies: {
              anyConsents: {
                oneOf: [
                  {
                    properties: {
                      anyConsents: {
                        enum: ['Yes']
                      },
                      consents: {
                        title: 'Consents',
                        type: 'array',
                        items: {
                          type: 'object',
                          properties: {
                            detailsOfConsent: {
                              type: 'string',
                              title: 'Details of consent'
                            },
                            targetDateToBeMet: {
                              type: 'string',
                              format: 'date',
                              title: 'Target date to be met'
                            }
                          },
                          required: ['detailsOfConsent', 'targetDateToBeMet']
                        }
                      }
                    }
                  },
                  {
                    properties: {
                      anyConsents: {
                        enum: ['No']
                      }
                    }
                  }
                ]
              }
            }
          },
          landOwnership: {
            type: 'object',
            title: 'Land Ownership',
            properties: {
              underControlOfLA: {
                type: 'string',
                title: 'Is land under control of the Local Authority',
                enum: ['Yes', 'No']
              },
            },
            required: ['underControlOfLA'],
            dependencies: {
              underControlOfLA: {
                oneOf: [
                  {
                    properties: {
                      underControlOfLA: {
                        enum: ['No']
                      },
                      ownershipOfLandOtherThanLA: {
                        type: 'string',
                        title: 'Who owns it?'
                      }
                    }
                  },
                  {
                    properties: {
                      underControlOfLA: {
                        enum: ['Yes']
                      },
                      landAcquisitionRequired: {
                        type: 'string',
                        title: 'Is land acquisition required?',
                        enum: ['Yes', 'No']
                      },
                    },
                    dependencies: {
                      landAcquisitionRequired: {
                        oneOf: [
                          {
                            properties: {
                              landAcquisitionRequired: {
                                enum: ['No']
                              },
                            }
                          },
                          {
                            properties: {
                              landAcquisitionRequired: {
                                enum: ['Yes']
                              },
                              howManySitesToAcquire: {
                                type: 'integer',
                                title: 'How many sites?'
                              },
                              toBeAcquiredBy: {
                                type: 'string',
                                title: 'Is this to be acquired by LA or developer?'
                              },
                              targetDateToAcquire: {
                                type: 'string',
                                format: 'date',
                                title: 'Target date to aquire sites'
                              },
                              summaryOfCriticalPath: {
                                type: 'string',
                                title: 'Summary of Critical Path'
                              }
                            }
                          }
                        ]
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
                title: 'Is the infrastructure contractor procured?',
                enum: ['Yes', 'No']
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
                        type: 'string',
                        title: 'Name of Contractor'
                      }
                    }
                  },
                  {
                    properties: {
                      contractorProcured: {
                        enum: ['No']
                      },
                      targetDate: {
                        type: 'string',
                        format: 'date',
                        title: 'Target date of procuring'
                      },
                      summaryOfCriticalPath: {
                        type: 'string',
                        title: 'Summary of critical path'
                      }
                    }
                  }
                ]
              }
            }
          },
          milestones: {
            type: 'array',
            title: 'Key Infrastructure Milestones',
            items: {
              type: 'object',
              properties: {
                descriptionOfMilestone: {
                  type: 'string',
                  title: 'Description of Milestone'
                },
                target: {
                  type: 'string',
                  format: 'date',
                  title: 'Target date of achieving'
                },
                summaryOfCriticalPath: {
                  type: 'string',
                  title: 'Summary of Critical Path'
                }
              }
            },
          },
          expectedInfrastructureStart: {
            type: 'object',
            title: 'Expected infrastructure start on site',
            properties: {
              targetDateOfAchievingStart: {
                type: 'string',
                format: 'date',
                title: 'Target date of achieving start'
              }
            }
          },
          expectedInfrastructureCompletion: {
            type: 'object',
            title: 'Expected infrastructure completion',
            properties: {
              targetDateOfAchievingCompletion: {
                type: 'string',
                format: 'date',
                title: 'Target date of achieving completion'
              }
            }
          },
          risksToAchievingTimescales: {
            type: 'array',
            title: 'Risks to achieving timescales',
            items: {
              type: 'object',
              properties: {
                descriptionOfRisk: {
                  type: 'string',
                  title: 'Description Of Risk'
                },
                impactOfRisk: {
                  type: 'string',
                  title: 'Impact'
                },
                likelihoodOfRisk: {
                  type: 'string',
                  title: 'Likelihood'
                },
                mitigationOfRisk: {
                  type: 'string',
                  title: 'Mitigation in place'
                }
              }
            }
          }
        }
      }
    }
  end

  def hif_summary
    {
      type: 'object',
      title: 'Project Summary',
      properties: {
        BIDReference: {
          type: 'string',
          title: 'BID Reference'
        },
        projectName: {
          type: 'string',
          title: 'Project Name'
        },
        leadAuthority: {
          type: 'string',
          title: 'Lead Authority'
        },
        jointBidAreas: {
          type: 'string',
          title: 'Joint Bid Areas',
        },
        projectDescription: {
          type: 'string',
          title: 'Project Description'
        },
        greenOrBrownField: {
          type: 'string',
          title: 'Greenfield/Brownfield/Mixed',
          enum: ['Greenfield', 'Brownfield', 'Mixed']
        },
        noOfHousingSites: {
          type: 'integer',
          title: 'Number of housing sites'
        },
        totalArea: {
          type: 'integer',
          title: 'Total Area (hectares)'
        },
        hifFundingAmount: {
          type: 'integer',
          title: 'HIF Funding Amount (£)'
        },
        descriptionOfInfrastructure: {
          type: 'string',
          title: 'Description of HIF Infrastructure to be delivered'
        },
        descriptionOfWiderProjectDeliverables: {
          type: 'string',
          title: 'Description of wider project deliverables'
        }
      }
    }
  end

  def hif_s151
    {
      type: 'object',
      title: 'Section 151',
      properties: {
        s151FundingEndDate: {
          type: 'string',
          format: 'date',
          title: 'HIF Funding End Date'
        },
        s151ProjectLongstopDate: {
          type: 'string',
          format: 'date',
          title: 'Project Longstop date'
        }
      }
    }
  end

  def outputs_forecast
    {
      type: 'object',
      title: 'Outputs - Forecast',
      properties: {
        totalUnits: {
          type: 'integer',
          title: 'Total Units'
        },
        disposalStrategy: {
          type: 'string',
          title: 'Disposal Strategy / Critical Path'
        },
        housingForecast: {
          type: 'array',
          title: 'Housing Forecast',
          items: {
            type: 'object',
            properties: {
              period: {
                type: 'string',
                title: 'Period'
              },
              target: {
                type: 'string',
                title: 'Housing Starts'
              },
              housingCompletions: {
                type: 'string',
                title: 'Housing Completions'
              }
            }
          }
        }
      }
    }
  end

  def outputs_actuals
    {
      type: 'object',
      title: 'Outputs - Actual',
      properties: {
        siteOutputs: {
          type: 'array',
          title: 'Site Outputs',
          items: {
            type: 'object',
            properties: {
              siteName: {
                type: 'string',
                title: 'Name of site'
              },
              siteLocalAuthority: {
                type: 'string',
                title: 'Local Authority'
              },
              siteNumberOfUnits: {
                type: 'string',
                title: 'Number of Units'
              }
            }
          }
        }
      }
    }
  end
end
