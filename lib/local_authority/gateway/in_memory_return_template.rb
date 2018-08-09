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
          projectName: nil,
          description: nil,
          leadAuthority: nil
        },
        infrastructure: [
          {
            type: nil,
            description: nil,
            completionDate: nil,
            submissionEstimated: nil,
            submissionActual: nil,
            submissionDelayReason: nil,
            targetGranted: nil,
            currentGranted: nil,
            reasonForVarianceGranted: nil
          }
        ],
        financial: {
          totalAmountEstimated: nil,
          totalAmountActual: nil,
          totalAmountChangedReason: nil
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
                title: 'Target Date of Submission',
                readonly: true
              },
              currentSubmission: {
                type: 'string',
                format: 'date',
                title: 'Current Submission Date'
              },
              reasonForVarianceSubmission: {
                type: 'string',
                title: 'Reason for submission date variance'
              },
              targetGranted: {
                type: 'string',
                format: 'date',
                title: 'Target date of planning granted',
                readonly: true
              },
              currentGranted: {
                type: 'string',
                format: 'date',
                title: 'Current planning granted date'
              },
              reasonForVarianceGranted: {
                type: 'string',
                title: 'Reason for granted date variance'
              }
            }
          }
        }
      }
    }
  end
end
