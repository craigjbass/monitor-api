# frozen_string_literal: true

class UI::Gateways
  def self.register(builder)
    builder.define_gateway :ui_project_schema do
      UI::Gateway::InMemoryProjectSchema.new
    end

    builder.define_gateway :ui_return_schema do
      UI::Gateway::InMemoryReturnSchema.new
    end
  end
end
