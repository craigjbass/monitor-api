# frozen_string_literal: true

class HomesEngland::Builder::Template::Templates::ACTemplate
  def create
    hif_template = HomesEngland::Domain::Template.new
    hif_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'AC Project',
      type: 'object',
      properties: {
        summary: ac_summary,
        infrastructures: ac_infrastructures,
        financial: ac_finances,
        s151: ac_s151,
        outputsForecast: ac_outputs_forecast,
        outputsActuals: ac_outputs_actuals
      }
    }

    hif_template
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

  def ac_infrastructures
    {}
  end

  def ac_finances
    {}
  end

  def ac_s151
    {}
  end

  def ac_outputs_forecast
    {}
  end

  def ac_outputs_actuals
    {}
  end
end
