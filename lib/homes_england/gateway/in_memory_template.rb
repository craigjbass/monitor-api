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
          lead_authority: nil,
          status: 'On Schedule'
        },
        infrastructure: {
          type: nil,
          description: nil,
          completion_date: nil
        },
        financial: {
          date: nil,
          funded_through_HIF: nil
        }
      }
    )
  end
end
