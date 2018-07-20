class HomesEngland::UseCases
  def self.register(builder)
    builder.define_use_case :project_gateway do
      HomesEngland::Gateway::FileProject.new(
        file_path: ENV['PROJECT_FILE_PATH']
      )
    end

    builder.define_use_case :create_new_project do
      HomesEngland::UseCase::CreateNewProject.new(
        project_gateway: builder.get_use_case(:project_gateway)
      )
    end

    builder.define_use_case :find_project do
      HomesEngland::UseCase::FindProject.new(
        project_gateway: builder.get_use_case(:project_gateway)
      )
    end
  end
end