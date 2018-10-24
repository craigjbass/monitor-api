# frozen_string_literal: true

class HomesEngland::UseCase::ValidateProject
  def initialize(project_template_gateway:, get_project_template_path_titles:)
    @project_template_gateway = project_template_gateway
    @get_project_template_path_titles = get_project_template_path_titles
  end

  def execute(type:, project_data:)
    schema = @project_template_gateway.get_template(type: type)
    
    invalid_paths = schema.invalid_paths(project_data)

    invalid_pretty_paths = invalid_paths.map do |path|
      @get_project_template_path_titles.execute(path: path, schema: schema.schema)[:path_titles]
    end

    {
      valid: invalid_paths.empty?,
      invalid_paths: invalid_paths,
      pretty_invalid_paths: invalid_pretty_paths
    }
  end
end
