# frozen_string_literal: true

class HomesEngland::Builder::Template::Templates::ACTemplate
  def create
    ac_template = HomesEngland::Domain::Template.new
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

  def ac_outputs
    {
      type: 'object',
      title: 'Outputs',
      properties: {
        unitCompletions: {
          type: 'object',
          title: 'Unit Completions',
          properties: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                year: {
                  type: 'integer',
                  title: 'Year'
                },
                Q1Amount: {
                  type: 'integer',
                  title: 'First Quarter'
                },
                Q2Amount: {
                  type: 'integer',
                  title: 'Second Quarter'
                },
                Q3Amount: {
                  type: 'integer',
                  title: 'Third Quarter'
                },
                Q4Amount: {
                  type: 'integer',
                  title: 'Fourth Quarter'
                }

              }
            }
          }
        },
        keyProgrammeObjectives: {
          type: 'object',
          title: 'Key Programme Objectives',
          properties: {
            localMarketPace: {
              type: 'number',
              title: 'Local Market Pace (units pm)'
            },
            schemePace: {
              type: 'number',
              title: 'Scheme Pace (units pm)'
            },
            mmcCategory: {
              type: 'object',
              title: 'MMC Category',
              properties: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    title: {
                      type: 'string',
                      title: 'Category Title'
                    },
                    percent: {
                      type: 'integer',
                      title: 'Percent Amount'
                    }
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
          type: 'object',
          title: 'Custom Milestones',
          properties: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                type: 'string',
                title: 'Custom (local authority entered)'
              }
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
          items: {
            type: 'object',
            properties: {
              fundingDrawdown: {
                year: {
                  type: 'integer',
                  title: 'Year'
                },
                Q1Amount: {
                  type: 'integer',
                  title: 'First Quarter'
                },
                Q2Amount: {
                  type: 'integer',
                  title: 'Second Quarter'
                },
                Q3Amount: {
                  type: 'integer',
                  title: 'Third Quarter'
                },
                Q4Amount: {
                  type: 'integer',
                  title: 'Fourth Quarter'
                }
              }
            }
          }
        },
        fundingStack: {
          type: 'object',
          title: 'Funding Stack',
          properties: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                year: {
                  type: 'string',
                  title: 'Year'
                },
                homesEnglandGrant: {
                  type: 'integer',
                  title: 'Homes England Grant'
                },
                otherSources: {
                  type: 'array',
                  items: {
                    type: 'object',
                    properties: {
                      fundingSource: {
                        type: 'integer',
                        title: 'Funding Source'
                      }
                    }
                  }
                }
              }
            }
          }
        },
        receipts: {
          detailsOnPaymentStructure: {
            type: 'string',
            title: 'Details on payment structure'
          },
          expectedDisposalReceipt: {
            type: 'object',
            title: 'Expected Disposal Receip',
            properties: {
              type: 'array',
              items: {
                type: 'object',
                properties: {
                  site: {
                    type: 'string',
                    title: 'Site'
                  },
                  amount: {
                    type: 'integer',
                    title: 'amount'
                  }
                }
              }
            }
          }
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
              type: 'array',
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
                  }
                }
              }
            }
          }
        },
        fundingItems: {
          type: 'object',
          title: 'Funding Items',
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
            }
          }
        }
      }
    }
  end

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
                    type: 'integer',
                    title: 'Total number of units'
                  },
                  numberOfUnitsMarket: {
                    type: 'integer',
                    title: 'Number units - market sale'
                  },
                  numberOfUnitsSharedOwnership: {
                    type: 'integer',
                    title: 'Number units - shared ownership'
                  },
                  numberOfUnitsAffordable: {
                    type: 'integer',
                    title: 'Number units - affordable/social rent'
                  },
                  numberOfUnitsPRS: {
                    type: 'integer',
                    title: 'Number units - PRS'
                  },
                  numberOfUnitsOther: {
                    type: 'integer',
                    title: 'Number units - Other'
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
                },

                planningStatus: {
                  type: 'string',
                  title: 'Planning status'
                },
                acFundingAgreed: {
                  type: 'integer',
                  title: 'AC funding agreed'
                }
              }
            }
          }
        }
      }
    }
  end
end
