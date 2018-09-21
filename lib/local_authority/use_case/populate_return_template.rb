# frozen_string_literal: true

class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(template_gateway:, find_path_data:, get_schema_copy_paths:)
    @template_gateway = template_gateway
    @find_path_data = find_path_data
    @get_schema_copy_paths = get_schema_copy_paths
  end

  def execute(type:, baseline_data:, return_data: {})
    source_data = create_root(baseline_data, return_data)
    populated_return = {}

    template_schema = @template_gateway.find_by(type: type).schema
    paths = @get_schema_copy_paths.execute(type: type)[:paths]
    paths.each do |copy_path_pair|
      populated_return = copy_data(
        copy_path_pair,
        source_data,
        template_schema,
        populated_return
      )
    end

    { populated_data: populated_return }
  end

  private

  def copy_data(copy_path_pair, source_data, template_schema, return_data)
    path_types = schema_types(template_schema, copy_path_pair[:to]).drop(1)

    found_data = @find_path_data.execute(
      source_data,
      copy_path_pair[:from]
    )[:found]

    descend_hash_and_bury(
      return_data,
      copy_path_pair[:to],
      path_types,
      found_data
    )
  end

  def descend_array(hash, path, path_types, value)
    return unless value.class == Array
    hash[path.first] = descend_array_and_bury(
      hash[path.first],
      path.drop(1),
      path_types.drop(1),
      value
    )
  end

  def descend_hash(hash, path, path_types, value)
    hash[path.first] = descend_hash_and_bury(
      hash[path.first],
      path.drop(1),
      path_types.drop(1),
      value
    )
  end

  # Burying is when we descend through a hash and look for our path where we place
  # our value if path_types contains arrays descend_array and bury will split up
  # the array of values that will exist
  def descend_hash_and_bury(hash, path, path_types, value)
    if last_node?(path)
      value
    else
      if node_is_array?(path_types)
        ensure_array_exists(hash, path)
        descend_array(hash, path, path_types, value)
      elsif node_is_object?(path_types)
        ensure_hash_exists(hash, path)
        descend_hash(hash, path, path_types, value)
      end
      hash
    end
  end

  def descend_array_and_bury(array, path, path_types, value)
    array = [] if array.nil?
    value.zip(array).map do |to_put, hash|
      hash = {} if hash.nil?
      descend_hash_and_bury(hash, path, path_types, to_put)
    end
  end

  def create_root(baseline_data, return_data)
    { baseline_data: baseline_data, return_data: return_data }
  end

  def last_node?(path)
    path.empty?
  end

  def node_is_array?(path_types)
    path_types.first == :array
  end

  def node_is_object?(path_types)
    path_types.first == :object
  end

  def ensure_hash_exists(hash, path)
    hash[path.first] = {} if hash[path.first].nil?
  end

  def ensure_array_exists(hash, path)
    hash[path.first] = [] if hash[path.first].nil?
  end

  # ! THE FOLLOWING IS CURRENTLY BEING MIGRATED TO A USE CASE !#
  def schema_types(schema, path)
    return [:not_found] if schema.nil?
    return [:object] if path.empty?
    return get_schema_types_from_array(path, schema) if schema[:type] == 'array'
    return get_schema_types_from_object(path, schema) if schema[:type] == 'object'
    [:unsupported_type]
  end

  def get_schema_types_from_array(path, schema)
    acquired_path = [:not_found]
    if array_has_property?(path, schema)
      acquired_path = get_path_types_from_array_properties(path, schema)
    end
    if array_has_item_dependencies?(schema) && path_not_found?(acquired_path)
      acquired_path = get_path_types_from_array_last_dependency(path, schema)
    end
    acquired_path
  end

  def get_schema_types_from_object(path, schema)
    acquired_path = [:not_found]

    if object_has_property(path, schema)
      acquired_path = get_path_types_from_object_properties(path, schema)
    end

    if object_has_dependencies(schema) && path_not_found?(acquired_path)
      acquired_path = get_path_types_object_last_dependency(path, schema)
    end

    [:object] + acquired_path
  end

  def path_not_found?(path)
    path.last == :not_found
  end

  def path_found?(path)
    path.last != :not_found
  end

  def get_path_types_from_array_last_dependency(path, schema)
    schema.dig(:items, :dependencies).values.each do |value|
      path_types = get_state_path(value, path)
      return [:array] + path_types if path_found?(path_types)
    end
  end

  def array_has_item_dependencies?(schema)
    Common::HashUtils.hash_has_path(schema, %i[items dependencies])
  end

  def get_path_types_from_array_properties(path, schema)
    [:array] + schema_types(schema.dig(:items, :properties, path.first), path.drop(1))
  end

  def array_has_property?(path, schema)
    Common::HashUtils.hash_has_path(schema, [:items, :properties, path.first])
  end

  def get_path_types_object_last_dependency(path, schema)
    schema[:dependencies].values.each do |value|
      path_types = get_state_path(value, path)
      return path_types if path_found?(path_types)
    end
  end

  def get_path_types_from_object_properties(path, schema)
    schema_types(schema[:properties][path.first], path.drop(1))
  end

  def object_has_dependencies(schema)
    Common::HashUtils.hash_has_path(schema, [:dependencies])
  end

  def object_has_property(path, schema)
    Common::HashUtils.hash_has_path(schema, [:properties, path.first])
  end

  def get_state_path(schema, path)
    schema[:oneOf].each do |value|
      path_types = get_path_from_object(value, path)
      return path_types if path_found?(path_types)
    end
    [:not_found]
  end

  def get_path_from_object(value, path)
    property = value.dig(:properties, path.first)
    schema_types(property, path.drop(1))
  end
end
