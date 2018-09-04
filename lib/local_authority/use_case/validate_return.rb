# frozen_string_literal: true

require 'json-schema'
class LocalAuthority::UseCase::ValidateReturn
  def initialize(return_template_gateway:)
    @return_template_gateway = return_template_gateway
  end

  def execute(type:, return_data:)
    schema = @return_template_gateway.find_by(type: type)
    { valid: JSON::Validator.validate(schema.schema.to_json, return_data)}
  end
end
