# frozen_string_literal: true

class HomesEngland::Gateway::InMemoryTemplate
  def initialize(template_builder:)
    @template_builder = template_builder
  end

  def get_template(type:)
    @template_builder.build_template(type: type)
  end
end
