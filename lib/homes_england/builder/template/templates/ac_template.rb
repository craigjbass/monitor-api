# frozen_string_literal: true

class HomesEngland::Builder::Template::Templates::ACTemplate
  def create
    ac_template = Common::Domain::Template.new
    ac_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'AC Project',
      type: 'object',
      properties: {
        summary: ac_summary,
        conditions: ac_conditions,
        financials: ac_financials,
        milestones: ac_milestones,
        outputs: ac_outputs
      }
    }
    ac_template
  end

  private

  def ac_summary
    {
      type: 'object',
      title: 'Project Summary',
      properties: {
        projectName: {
          type: 'string',
          title: 'Project Name'
        },
        projectRef: {
          type: 'string',
          title: 'Project reference'
        },
        projectDescription: {
          type: 'string',
          title: 'Project Description'
        },
        localAuthority: {
          type: 'string',
          title: 'Local Authority'
        },
        sitesSummary: {
          type: 'array',
          addable: true,
          title: 'Site(s) Summary',
          items: {
            type: 'object',
            properties: {
              name: {
                type: 'string',
                title: 'Parcel/Sub Site name'
              },
              ref: {
                type: 'string',
                title: 'LMT / GIS ref'
              },
              size: {
                type: 'string',
                title: 'Size (Ha)'
              },
              laContact: {
                type: 'string',
                title: 'Key local authority contact'
              },
              heContact: {
                type: 'string',
                title: 'Key Homes England contact'
              },
              units: {
                type: 'object',
                title: 'Units',
                properties: {
                  numberOfUnitsTotal: {
                    type: 'string',
                    title: 'Total number of units'
                  },
                  numberOfUnitsMarket: {
                    type: 'string',
                    title: 'Number units - market sale'
                  },
                  numberOfUnitsSharedOwnership: {
                    type: 'string',
                    title: 'Number units - shared ownership'
                  },
                  numberOfUnitsAffordable: {
                    type: 'string',
                    title: 'Number units - affordable/social rent'
                  },
                  numberOfUnitsPRS: {
                    type: 'string',
                    title: 'Number units - PRS'
                  },
                  numberOfUnitsOther: {
                    type: 'string',
                    title: 'Number units - Other'
                  },
                  planningStatus: {
                    type: 'string',
                    title: 'Planning status'
                  }
                }
              },
              requestChange: {
                type: 'object',
                title: 'Request to change units or tenure mix',
                properties: {
                  requestToChangeUnits: {
                    type: 'string',
                    title: 'Requested',
                    enum: %w[Yes No]
                  }
                },
                dependencies: {
                  requestToChangeUnits: {
                    oneOf: [
                      {
                        properties: {
                          requestToChangeUnits: {
                            enum: ['No']
                          }
                        }
                      }, {
                        properties: {
                          requestToChangeUnits: {
                            enum: ['Yes']
                          },
                          reason: {
                            type: 'string',
                            title: 'Reason/explanation'
                          },
                          review: {
                            type: 'string',
                            format: 'date',
                            title: 'Reviewed and approved'
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
        acFundingAgreed: {
          readonly: true,
          type: 'string',
          title: 'AC funding agreed'
        }
      }
    }
  end

  def ac_conditions
    {
      type: 'object',
      title: 'Conditions',
      properties: {
        predrawdownConditions: {
          type: 'object',
          title: 'Pre-Drawdown Conditions',
          properties: {
            conditions: {
              title: 'Conditions',
              type: 'array',
              addable: true,
              items: {
                type: 'object',
                properties: {
                  conditionName: {
                    type: 'string',
                    title: 'Condition Name'
                  },
                  conditionExplanation: {
                    type: 'string',
                    title: 'Condition explanation'
                  },
                  conditionSite: {
                    type: 'string',
                    title: 'Site (if multiple)'
                  },
                  conditionForecast: {
                    type: 'string',
                    title: 'Condition Forecast',
                    format: 'date'
                  },
                  conditionMet: {
                    type: 'string',
                    title: 'Condition Met',
                    format: 'date'
                  },
                  reviewed: {
                    type: 'string',
                    title: 'Reviewed and Approved',
                    format: 'date'
                  }
                }
              }
            },
            mitigationsAndAssurance: {
              type: 'string',
              title: 'Mitigations and Assurance',
              format: 'textarea'
            }
          }
        },
        fundingItems: {
          type: 'object',
          title: 'Funding Items',
          properties: {
            fundItems: {
              title: 'Items',
              type: 'array',
              addable: true,
              items: {
                type: 'object',
                properties: {
                  fundingItem: {
                    type: 'string',
                    title: 'Funding item'
                  },
                  fundingSite: {
                    type: 'string',
                    title: 'Site (if multiple)'
                  },
                  fundingAgreed: {
                    type: 'string',
                    title: 'AC Funding agreed'
                  },
                  fundingRequired: {
                    type: 'string',
                    title: 'AC Funding Required'
                  },
                  variance: {
                    type: 'string',
                    readonly: true,
                    title: 'Variance'
                  },
                  reasonForVariance: {
                    type: 'string',
                    title: 'Reason for Variance'
                  }
                }
              }
            },
            mitigationsAndAssurance: {
              type: 'string',
              title: 'Mitigations and Assurance',
              format: 'textarea'
            }
          }
        }
      }
    }
  end

  def ac_financials
    {
      type: 'object',
      title: 'Financials',
      properties: {
        expenditure: {
          type: 'array',
          title: 'Expenditure',
          items: {
            type: 'object',
            properties: {
              fundingDrawdown: {
                type: 'object',
                horizontal: true,
                title: 'Funding Drawdown',
                properties: {
                  year: {
                    type: 'string',
                    title: 'Year'
                  },
                  Q1Amount: {
                    type: 'string',
                    title: 'First Quarter'
                  },
                  Q2Amount: {
                    type: 'string',
                    title: 'Second Quarter'
                  },
                  Q3Amount: {
                    type: 'string',
                    title: 'Third Quarter'
                  },
                  Q4Amount: {
                    type: 'string',
                    title: 'Fourth Quarter'
                  }
                }
              }
            }
          }
        },
        fundingStack: {
          type: 'array',
          addable: true,
          title: 'Funding Stack',
          items: {
            type: 'object',
            properties: {
              year: {
                type: 'string',
                title: 'Year'
              },
              homesEnglandGrant: {
                type: 'string',
                title: 'Homes England Grant'
              },
              otherSources: {
                type: 'array',
                title: 'Other Sources',
                items: {
                  type: 'object',
                  properties: {
                    fundingSource: {
                      type: 'string',
                      title: 'Funding Source'
                    }
                  }
                }
              }
            }
          }
        },
        receipts: {
          type: 'object',
          title: 'Receipts',
          properties: {
            detailsOnPaymentStructure: {
              type: 'string',
              title: 'Details on payment structure'
            },
            expectedDisposalReceipt: {
              type: 'array',
              addable: true,
              title: 'Expected Disposal Receipt',
              items: {
                type: 'object',
                properties: {
                  site: {
                    type: 'string',
                    title: 'Site'
                  },
                  amount: {
                    type: 'string',
                    title: 'Amount'
                  }
                }
              }
            }
          }
        }
      }
    }
  end

  def ac_milestones
    {
      type: 'object',
      title: 'Milestones',
      properties: {
        description: {
          type: 'string',
          title: 'Description of disposal and delivery approach'
        },
        procurementOfWorksCommencementDate: {
          type: 'string',
          format: 'date',
          title: 'Procurement of works commencement date'
        },
        provisionOfDetailedWorks: {
          type: 'string',
          format: 'date',
          title: 'Provision of detailed works specification and milestones'
        },
        commencementDate: {
          type: 'string',
          format: 'date',
          title: 'Commencement of works date (first, if multiple)'
        },
        completionDate: {
          type: 'string',
          format: 'date',
          title: 'Completion of works date (last, if multiple)'
        },
        outlinePlanningSubmissionDate: {
          type: 'string',
          format: 'date',
          title: 'Outline planning permission submitted date'
        },
        outlinePlanningGrantedDate: {
          type: 'string',
          format: 'date',
          title: 'Outline planning permission granted date'
        },
        detailedPlanningSubmissionDate: {
          type: 'string',
          format: 'date',
          title: 'Detailed planning permission submitted date'
        },
        detailsPlanningGrantedDate: {
          type: 'string',
          format: 'date',
          title: 'Detailed planning permission granted date'
        },
        marketingCommenced: {
          type: 'string',
          format: 'date',
          title: 'Developer Partner marketing commenced (EOI or formal tender)'
        },
        conditionalContractSigned: {
          type: 'string',
          format: 'date',
          title: 'Conditional contract signed'
        },
        unconditionalContractSigned: {
          type: 'string',
          format: 'date',
          title: 'Unconditional contract signed'
        },
        typeOfContract: {
          type: 'string',
          title: 'Type of contract (eg Building Lease)'
        },
        nameOfDeliveryPartner: {
          type: 'string',
          title: 'Name of delivery partner/purchaser'
        },
        startOnSiteDate: {
          type: 'string',
          format: 'date',
          title: 'Start on site date'
        },
        startOnFirstUnitDate: {
          type: 'string',
          format: 'date',
          title: 'Start of first unit date'
        },
        developmentEndDate: {
          type: 'string',
          format: 'date',
          title: 'Development end date (final unit completion)'
        },
        customMileStones: {
          type: 'array',
          addable: true,
          title: 'Custom Milestones',
          items: {
            type: 'object',
            properties: {
              custom: {
                type: 'string',
                title: 'Milestone'
              },
              customDate: {
                type: 'string',
                title: 'Date',
                format: 'date'
              }
            }
          }
        }
      }
    }
  end

  def ac_outputs
    {
      type: 'object',
      title: 'Outputs',
      properties: {
        unitCompletions: {
          title: 'Unit Completions',
          type: 'array',
          items: {
            type: 'object',
            properties: {
              year: {
                type: 'string',
                title: 'Year'
              },
              Q1Amount: {
                type: 'string',
                title: 'First Quarter'
              },
              Q2Amount: {
                type: 'string',
                title: 'Second Quarter'
              },
              Q3Amount: {
                type: 'string',
                title: 'Third Quarter'
              },
              Q4Amount: {
                type: 'string',
                title: 'Fourth Quarter'
              }
            }
          }
        },
        keyProgrammeObjectives: {
          type: 'object',
          title: 'Key Programme Objectives',
          properties: {
            localMarketPace: {
              type: 'string',
              title: 'Local Market Pace (units pm)'
            },
            schemePace: {
              type: 'string',
              title: 'Scheme Pace (units pm)'
            },
            mmcCategory: {
              title: 'MMC Category',
              type: 'array',
              addable: true,
              items: {
                type: 'object',
                properties: {
                  title: {
                    type: 'string',
                    title: 'Category Title'
                  },
                  percent: {
                    type: 'string',
                    title: 'Percent Amount'
                  }
                }
              }
            },
            startOfFirstUnit: {
              type: 'string',
              format: 'date',
              title: 'Start of first unit'
            },
            completionOfFinalUnit: {
              type: 'string',
              format: 'date',
              title: 'Completion of final unit'
            }
          }
        }
      }
    }
  end
end
