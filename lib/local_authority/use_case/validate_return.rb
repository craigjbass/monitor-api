# frozen_string_literal: true

require 'json-schema'
class LocalAuthority::UseCase::ValidateReturn
  def initialize(return_template_gateway:)
    @return_template_gateway = return_template_gateway
  end

  def execute(type:, return_data:)
    schema = @return_template_gateway.find_by(type: type)

    invalid_paths = schema.invalid_paths(return_data)

    { valid: invalid_paths.empty?,
      invalid_paths: invalid_paths }
  end
end
