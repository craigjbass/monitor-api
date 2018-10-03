class HomesEngland::Gateways
  def self.register(builder)
    builder.define_gateway :project do
      HomesEngland::Gateway::SequelProject.new(database: builder.database)
    end

    builder.define_gateway :template do
      HomesEngland::Gateway::InMemoryTemplate.new(
        template_builder: builder.get_use_case(:template_builder)
      )
    end

    builder.define_gateway :template_builder do
      HomesEngland::Builder::Template::TemplateBuilder.new
    end
  end
end

