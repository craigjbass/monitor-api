# frozen_string_literal: true

class HomesEngland::Builder::Template::TemplateBuilder
  def build_template(type:)
    if type == 'hif'
      HomesEngland::Builder::Template::Templates::HIFTemplate.new.create
    elsif type == 'ac'
      HomesEngland::Builder::Template::Templates::ACTemplate.new.create
    end
  end
end
