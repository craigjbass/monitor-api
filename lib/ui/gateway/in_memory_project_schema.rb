# frozen_string_literal: true

class UI::Gateway::InMemoryProjectSchema
  def find_by(type:)
    if type == 'hif'
      template = Common::Domain::Template.new
      template.schema = JSON.parse(
        File.open("#{__dir__}/schemas/hif_project.json", 'r').read,
        symbolize_names: true
      )
      template
    elsif type == 'ac'
      template = Common::Domain::Template.new
      template.schema = JSON.parse(
        File.open("#{__dir__}/schemas/ac_project.json", 'r').read,
        symbolize_names: true
      )
      template
    end
  end
end
