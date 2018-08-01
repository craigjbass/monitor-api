# frozen_string_literal: true

class HomesEngland::Gateway::InMemoryTemplate
  def initialize; end

  def get_template(type:)
    return nil unless type == 'hif'
    hif_template = HomesEngland::Domain::Template.new
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
