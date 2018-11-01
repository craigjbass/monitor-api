# frozen_string_literal: true

class UI::Gateway::InMemoryProjectSchema
  def find_by(type:)
    return nil unless type == 'hif'
    template = Common::Domain::Template.new
    template.schema = JSON.parse(
      File.open("#{__dir__}/schemas/hif.json", 'r').read,
      symbolize_names: true
    )
    template
  end
end
