class LocalAuthority::UseCase::GetReturnTemplatePathTitles
  using LocalAuthority::Refinement::HashHasPath

  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:, path:)
    schema = @template_gateway.find_by(type: type)
    { path_titles: clean_missing_form_title(schema_types(schema.schema, path)) }
  end

  private

  def clean_missing_form_title(titles)
    if titles.first.nil?
      titles.shift
      titles = ['[form]'] + titles
    end
    titles
  end

  def schema_types(schema, path)
    return [:not_found] if schema.nil?
    return [schema[:title]] if path.empty?
    return get_schema_types_from_array(path, schema) if schema[:type] == 'array'
    return get_schema_types_from_object(path, schema) if schema[:type] == 'object'

    [:unsupported_type]
  end

  def get_schema_types_from_array(path, schema)
    acquired_path = [:not_found]
    if array_has_property?(path, schema)
      acquired_path = get_path_titles_from_array_properties(path, schema)
    end
    if array_has_item_dependencies?(schema) && path_not_found?(acquired_path)
      acquired_path = get_path_titles_from_array_dependencies(path, schema)
    end

    acquired_path
  end

  def get_schema_types_from_object(path, schema)
    acquired_path = [:not_found]

    if object_has_property(path, schema)
      acquired_path = get_path_titles_from_object_properties(path, schema)
    end

    if object_has_dependencies(schema) && path_not_found?(acquired_path)
      acquired_path = get_path_titles_from_object_dependencies(path, schema)
    end

    acquired_path[0] = "[#{path.first}]" if acquired_path.first.nil?

    [schema[:title]] + acquired_path
  end

  def path_not_found?(path)
    path.last == :not_found
  end

  def path_found?(path)
    path.last != :not_found
  end

  def get_path_titles_from_array_dependencies(path, schema)
    schema.dig(:items, :dependencies).values.each do |value|
      path_titles = get_state_path(value, path)
      return [schema[:title]] + path_titles if path_found?(path_titles)
    end
  end

  def array_has_item_dependencies?(schema)
    schema.hash_has_path?(%i[items dependencies])
  end

  def get_path_titles_from_array_properties(path, schema)
    acquired_path = [schema[:title], schema.dig(:items, :title)] + schema_types(schema.dig(:items, :properties, path.first), path.drop(1))
    unless schema.hash_has_path?([:items, :title])
      acquired_path[1] = "[item]"
    end

    unless schema.hash_has_path?([:items, :properties, path.first, :title])
      acquired_path[2] = "[#{path.first}]"
    end

    acquired_path
  end

  def array_has_property?(path, schema)
    schema.hash_has_path?([:items, :properties, path.first])
  end

  def get_path_titles_from_object_dependencies(path, schema)
    schema[:dependencies].values.each do |value|
      path_titles = get_state_path(value, path)
      return path_titles if path_found?(path_titles)
    end
  end

  def get_path_titles_from_object_properties(path, schema)
    schema_types(schema[:properties][path.first], path.drop(1))
  end

  def object_has_dependencies(schema)
    schema.hash_has_path?([:dependencies])
  end

  def object_has_property(path, schema)
    schema.hash_has_path?([:properties, path.first])
  end

  def get_state_path(schema, path)
    schema[:oneOf].each do |value|
      path_titles = get_path_from_object(value, path)
      return path_titles if path_found?(path_titles)
    end
    [:not_found]
  end

  def get_path_from_object(value, path)
    property = value.dig(:properties, path.first)
    schema_types(property, path.drop(1))
  end
end
