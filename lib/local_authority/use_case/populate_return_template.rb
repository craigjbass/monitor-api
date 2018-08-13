class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(template_gateway:, find_baseline_path:, get_schema_copy_paths:)
    @template_gateway = template_gateway
    @find_baseline_path = find_baseline_path
    @get_schema_copy_paths = get_schema_copy_paths
  end

  def execute(type:, baseline_data:)
    populated_return = {}
    template_schema = @template_gateway.find_by(type: type).schema
    @get_schema_copy_paths.execute(type: type)[:paths].each do |copy_paths|
      path_types = schemaTypes(template_schema, copy_paths[:to]).drop(1)
      descend_hash_and_bury(
        populated_return,
        copy_paths[:to],
        path_types,
        @find_baseline_path.execute(baseline_data, copy_paths[:from])[:found]
      )
    end
    { populated_data: populated_return }
  end

  private

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

  def descend_array(hash, path, path_types, value)
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

  #Burying is when we descend through a hash and look for our path where we place
  #our value if path_types contains arrays descend_array and bury will split up
  #the array of values that will exist
  def descend_hash_and_bury(hash, path, path_types, value)
    if last_node?(path)
      value
    else
      if node_is_array?(path_types)
        ensure_array_exists(hash, path)
        descend_array(hash, path, path_types, value)
      elsif node_is_object?(path_types)
        ensure_hash_exists(hash,path)
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

  def schemaTypes(schema, path)
    if path.empty?
      [:object]
    elsif schema[:type] == 'array'
      [:array] + schemaTypes(schema[:items][:properties][path[0]], path.drop(1))
    elsif schema[:type] == 'object'
      [:object] + schemaTypes(schema[:properties][path[0]], path.drop(1))
    end
  end
end
