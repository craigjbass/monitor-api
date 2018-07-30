# frozen_string_literal: true

class HomesEngland::Gateway::InMemoryTemplate
  def initialize; end

  def get_template(type:)
    return nil unless type == 'hif'
    HomesEngland::Domain::Template.new(
      layout: {
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
    )
  end
end
