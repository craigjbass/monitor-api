class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(template_gateway:, find_baseline_path:, get_schema_copy_paths:)
    @template_gateway = template_gateway
    @find_baseline_path = find_baseline_path
    @get_schema_copy_paths = get_schema_copy_paths
  end

  def execute(type:, baseline_data:)
    populated_return = {}
    template_schema = @template_gateway.find_by(type: type).schema
    @get_schema_copy_paths.execute(template_schema: template_schema).each do |copy_paths|
      path_types = schemaTypes(template_schema, copy_paths[:to]).drop(1)
      bury_hash(populated_return, copy_paths[:to], path_types, @find_baseline_path.execute(baseline_data, copy_paths[:from]))
    end
    { populated_data: populated_return }
  end

  private
  def bury_hash(hash, path, path_types, value)
    if path.empty?
      value
    else
      if path_types.first == :array
        if hash[path.first].nil?
          hash[path.first] = []
        end
        hash[path.first] = bury_array(hash[path.first], path.drop(1), path_types.drop(1), value)
      elsif path_types.first == :object
        if hash[path.first].nil?
          hash[path.first] = {}
        end
        hash[path.first] = bury_hash(hash[path.first], path.drop(1), path_types.drop(1), value)
      end
      hash
    end
  end

  def bury_array(array, path, path_types, value)
    if path.empty?
      value
    else
      if array.nil?
        array = []
      end
      array = value.zip(array).map do |to_put, hash|
        if hash.nil?
          hash = {}
        end
        bury_hash(hash, path, path_types, to_put)
      end
    end
    array
  end

  #Move this into a use case
  def schemaTypes(schema, path)
    if path.empty?
      [:object]
    else
      if schema[:type] == 'array'
        [:array] + schemaTypes(schema[:items][:properties][path[0]], path.drop(1))
      elsif schema[:type] == 'object'
        [:object] + schemaTypes(schema[:properties][path[0]], path.drop(1))
      end
    end
  end
end
