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
          infrastructures: hif_infrastructures
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

  def hif_infrastructures
    {
      type: 'array',
      title: 'Infrastructures',
      items: {
        type: 'object',
        properties: {
          outlinePlanningStatus: {
            type: 'object',
            title: 'Outline Planning Status',
            properties: {
              targetSubmission: {
                type: 'string',
                format: 'date',
                title: 'If No: Target date of submission',
                readonly: true
              },
              currentSubmission: {
                type: 'string',
                format: 'date',
                title: 'If No: Target date of submission'
              },
              reasonForVarianceSubmission: {
                type: 'string',
                title: 'If No: Target date of submission'
              },
              targetGranted: {
                type: 'string',
                format: 'date',
                title: 'If No: Target date of planning granted',
                readonly: true
              },
              currentGranted: {
                type: 'string',
                format: 'date',
                title: 'If No: Target date of submission'
              },
              reasonForVarianceGranted: {
                type: 'string',
                title: 'If No: Target date of submission'
              }
            }
          }
        }
      }
    }
  end
end
