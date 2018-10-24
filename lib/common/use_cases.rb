class Common::UseCases
  def self.register(builder)
    builder.define_use_case :get_template_path_titles do
      Common::UseCase::GetTemplatePathTitles.new
    end
  end
end
