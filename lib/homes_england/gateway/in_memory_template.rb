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
            BIDReference: { type: 'string', title: 'BID Reference' },
            projectName: { type: 'string', title: 'Project Name' },
            leadAuthority: { type: 'string', title: 'Lead Authority' }
          }
        },
        infrastructure: {
          type: 'object',
          title: 'Infrastructure',
          properties: {
            infraType: { type: 'string', title: 'Type' },
            description: { type: 'string', title: 'Description' },
            completionDate: {
              type: 'string',
              format: 'date',
              title: 'Completion Date'
            },
            planning: {
              type: 'object',
              title: 'Planning permission',
              properties: {
                submissionEstimated: {
                  type: 'string',
                  format: 'date',
                  title: 'Estimated date of submission'
                }
              }
            }
          }
        },
        financial: {
          type: 'object',
          title: 'Financial information',
          properties: {
            totalAmountEstimated: {
              type: 'string',
              title: 'Estimated total amount required'
            }
          }
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
