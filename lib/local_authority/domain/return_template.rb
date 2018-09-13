class LocalAuthority::Domain::ReturnTemplate
  attr_accessor :layout, :schema

  def invalid_paths(the_return)
    messages = validation_messages_for(the_return)

    paths = messages.map do |m|
      json_properties = json_properties_for(m)
      path_for(json_properties) unless json_properties.nil?
    end.compact

    paths || []
  end

  private

  def validation_messages_for(return_data)
    JSON::Validator.fully_validate(
      schema.to_json,
      return_data
    )
  end

  def json_properties_for(message)
    ignore_json_property_root = %r{#/}
    capture_json_property = %r{([\w/]*)}
    ignore_until = /.*/
    message_parse_regex = /
      '
        #{ignore_json_property_root}
    #{capture_json_property}
      '
      #{ignore_until}
      '
        #{capture_json_property}
      '
    /x
    message.match(message_parse_regex)&.captures&.to_a&.reject(&:empty?)
  end

  def json_property_name_to_path(property)
    property.split('/').map do |node|
      begin
        Integer(node)
      rescue ArgumentError
        node.to_sym
      end
    end
  end

  def join_path_array(array_of_paths)
    array_of_paths.flatten
  end

  def path_for(properties)
    json_paths = properties.map do |property|
      json_property_name_to_path(property)
    end
    join_path_array(json_paths)
  end
end
