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

  def create_root(baseline_data, return_data)
    { baseline_data: baseline_data, return_data: return_data }
  end

  def copy_data(copy_path_pair, source_data, template_schema, return_data)
    path_types = schema_types(template_schema, copy_path_pair[:to]).drop(1)

    found_data = @find_path_data.execute(
      source_data,
      copy_path_pair[:from]
    )[:found]

    p path_types
    p found_data, copy_path_pair[:to]

    descend_hash_and_bury(
      return_data,
      copy_path_pair[:to],
      path_types,
      found_data
    )
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

  def descend_array(hash, path, path_types, value)
    if value.class == Array
      hash[path.first] = descend_array_and_bury(
        hash[path.first],
        path.drop(1),
        path_types.drop(1),
        value
      )
    end
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

  def schema_types(schema, path)

    if schema.nil?
      #Maybe a good idea to replace this with a custom exception
      [:not_found]
    elsif path.empty?
      [:object]
    elsif schema[:type] == 'array'
      # This is failing because it isn't going to find the path because it only descends on properties not on dependencies stuff, we need to
      # begin on properties and then rescue with the other thingy
      [:array] + schema_types(schema[:items][:properties][path[0]], path.drop(1))
    elsif schema[:type] == 'object'
      acquired_path = [:not_found]

      unless schema.dig(:properties, path[0]).nil?
        acquired_path = schema_types(schema[:properties][path[0]], path.drop(1))
      end
      # If our initial attempt to acquire a path from properties failed look for it under dependencies
      if !schema[:dependencies].nil? && acquired_path[-1] == :not_found
        schema[:dependencies].each do |_key, value|
          value[:oneOf].each do |possibility|
            acquired_path = schema_types(possibility[:properties][path[0]], path.drop(1))
          end
        end
      end

      if acquired_path.nil?
        [:object]
      else
        [:object] + acquired_path
      end
    end
  end
end
