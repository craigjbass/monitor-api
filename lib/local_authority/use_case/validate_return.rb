# frozen_string_literal: true

require 'json-schema'
class LocalAuthority::UseCase::ValidateReturn
  def initialize(return_template_gateway:,get_return_template_path_titles:)
    @return_template_gateway = return_template_gateway
    @get_return_template_path_titles = get_return_template_path_titles
  end

  def execute(type:, return_data:)
    schema = @return_template_gateway.find_by(type: type)

    invalid_paths = schema.invalid_paths(return_data)

    invalid_pretty_paths = invalid_paths.map do |path|
      @get_return_template_path_titles.execute(type: type, path: path)[:path_titles]
    end

    {
      valid: invalid_paths.empty?,
      invalid_paths: invalid_paths,
      pretty_invalid_paths: invalid_pretty_paths
    }
  end
end
