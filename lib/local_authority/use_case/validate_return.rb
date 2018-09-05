# frozen_string_literal: true

require 'json-schema'
class LocalAuthority::UseCase::ValidateReturn
  def initialize(return_template_gateway:)
    @return_template_gateway = return_template_gateway
  end

  def execute(type:, return_data:)
    schema = @return_template_gateway.find_by(type: type)
    valid = JSON::Validator.validate(schema.schema.to_json, return_data)
    invalid_paths = valid ? [] : get_paths_from_error_messages(schema, return_data)
    { valid: valid,
      invalid_paths: invalid_paths }
  end

  def get_paths_from_error_messages(schema, return_data)
    fully_validate = JSON::Validator.fully_validate(schema.schema.to_json, return_data)
    fully_validate.map do |message|
      json_property_name_regex_capture = %r{([\w\/]*)}
      message_parse_regex = %r{
        '\#/
          #{json_property_name_regex_capture}
        '
        .*
        '
          #{json_property_name_regex_capture}
        '
      }x
      message.scan(message_parse_regex).map do |match|
        match.reject(&:empty?).map do |path|
          path.split('/').map do |node|
            begin
              Integer(node)
            rescue ArgumentError
              node.to_sym
            end
          end
        end.flatten
      end.first
    end.compact
  end
end
