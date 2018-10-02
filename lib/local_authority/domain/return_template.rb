require 'json_schema'
class LocalAuthority::Domain::ReturnTemplate
  attr_accessor :layout, :schema

  def invalid_paths(return_data)
    schema = parse_json_schema(@schema)
    get_invalid_paths(schema, return_data) || []
  end

  private

  def parse_json(schema)
    JSON.parse(schema.to_json)
  end

  def parse_json_schema(schema)
    JsonSchema.parse!(parse_json(schema))
  end

  def validate_json_schema(schema, return_data)
    schema.validate!(parse_json(return_data))
  end

  def get_invalid_paths(schema, return_data)
    validate_json_schema(schema, return_data)
    nil
  rescue JsonSchema::AggregateError => aggregated_errors
    get_supported_errors(aggregated_errors).map do |error|
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
