# frozen_string_literal: true

class HomesEngland::Gateway::InMemoryTemplate
  def initialize; end

  def get_template(type:)
    return nil unless type == 'hif'
    hif_template = HomesEngland::Domain::Template.new
    hif_template.schema = {
      '$schema': 'http://json-schema.org/draft-07/schema',
      title: 'HIF Project',
      type: 'object',
      properties: {
        projectSummary: {
          type: 'object',
          title: 'Project Summary',
          properties: {
            BIDReference: {
              type: 'string', title: 'BID Reference'
            },
            projectName: {
              type: 'string', title: 'Project Name'
            },
            leadAuthority: {
              type: 'string', title: 'Lead Authority'
            },
            projectDescription: {
              type: 'string', title: 'Project Description'
            },
            noOfHousingSites: {
              type: 'integer', title: 'Number of housing sites'
            },
            totalArea: {
              type: 'integer', title: 'Total Area (hectares)'
            },
            hifFundingAmount: {
              type: 'integer', title: 'HIF Funding Amount (£)'
            },
            descriptionOfInfrastructure: {
              type: 'string', title: 'Description of HIF Infrastructure to be delivered'
            },
            descriptionOfWiderProjectDeliverables: {
              type: 'string', title: 'Description of wider project deliverables'
            }
          }
        },
        infrastructures: {
          type: 'array',
          title: 'Infrastructures',
          items: [
            infraType: { type: 'string', title: 'Type' },
            description: { type: 'string', title: 'Description' }
          ]
        },
        financial: {
          type: 'array',
          title: 'Financials',
          items: [
            amount: { type: 'string', title: 'Amount' }
          ]
        }
      },
      required: ['financial', 'infrastructure', 'summary']
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
end
