# frozen_string_literal: true

class LocalAuthority::Gateway::InMemoryReturnTemplate

  def find_by(type:)
    return nil unless type == 'hif'
    LocalAuthority::Domain::ReturnTemplate.new.tap do |p|
      p.schema = {
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
                  },
                  submissionActual: {
                    type: 'string',
                    format: 'date',
                    title: 'Actual date of submission'
                  },
                  submissionDelayReason: {
                    type: 'string',
                    format: 'date',
                    title: 'Reason for delay'
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
              },
              totalAmountActual: {
                type: 'string',
                title: 'Actual total amount required'
              },
              totalAmountChangedReason: {
                type: 'string',
                title: 'Reason for change in amount'
              }
            }
          }
        },
        required: ['financial', 'infrastructure', 'summary']
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
