# frozen_string_literal: true

require 'json_schema'
class Common::Domain::Template
  attr_accessor :layout, :schema

  def invalid_paths(project_data)
    schema = parse_json_schema(@schema)
    get_invalid_paths(schema, project_data) || []
  end

  private

  def parse_json(schema)
    JSON.parse(schema.to_json)
  end

  def parse_json_schema(schema)
    JsonSchema.parse!(parse_json(schema))
  end

  def validate_json_schema(schema, project_data)
    schema.validate!(parse_json(project_data))
  end

  def get_invalid_paths(schema, project_data)
    validate_json_schema(schema, project_data)
    nil
  rescue JsonSchema::AggregateError => aggregated_errors
    get_supported_errors(aggregated_errors).map do |error|
      pp error
      error_path = error.path.drop(1)
      error_path += get_required_failed_node_name(error) if error.type == :required_failed
      symbolize_path(error_path)
    end
  end

  def get_required_failed_node_name(error)
    error.data
  end

  def get_supported_errors(aggregated_errors)
    aggregated_errors.errors.select do |error|
      %i[required_failed one_of_failed].include? error.type
    end
  end

  def symbolize_path(path)
    path.map do |node|
      if node.class == String
        node.to_sym
      else
        node
      end
    end
  end
end
