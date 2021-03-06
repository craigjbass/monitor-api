# frozen_string_literal: true

class UI::Gateway::InMemoryProjectSchema
  def find_by(type:)
    if type == 'hif'
      schema = 'hif_project.json'
    elsif type == 'ac'
      schema = 'ac_project.json'
    else
      return nil
    end
    create_template(schema)
  end

  private

  def create_template(schema)
    template = Common::Domain::Template.new
    template.schema = JSON.parse(
      File.open("#{__dir__}/schemas/#{schema}", 'r').read,
      symbolize_names: true
    )
    template
  end
end
