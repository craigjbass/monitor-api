class LocalAuthority::UseCase::PopulateReturnTemplate
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:, baseline_data:)
    schema = @template_gateway.find_by(type: type).schema

    {populated_data: descend_hash(schema[:properties],baseline_data)}
  end

  private

  # {:animalName=>{:baselineKey=>["pets", "animalType"]}}
  # {:pets=>[{:animalType=>"cat"}]}
  def descend_array(schema_data, baseline_data)
    key = schema_data.keys.first
    base_array_key = schema_data.values.first[:baselineKey].first.to_sym
    base_value_key = schema_data.values.first[:baselineKey].last.to_sym

    baseline_data[base_array_key].map do |base_array_value|
      ret = {}
      ret[key] = find_value_in_baseline(base_array_value, {baselineKey: [base_value_key]})
      ret
    end
  end
  
  def descend_hash(schema_data, baseline_data)
    populated_data = {}

    schema_data.each do |key,value|
      if value[:type] == 'object'
        populated_data[key] = descend_hash(value[:properties], baseline_data)
      elsif value[:type] == 'array'
        populated_data[key] = descend_array(value[:items][:properties], baseline_data)
      else
        populated_data[key] = find_value_in_baseline(baseline_data, value)
      end
    end

    populated_data
  end
  
  def value_populated_from_baseline?(value) 
    !value[:baselineKey].nil?
  end

  def find_value_in_baseline(baseline_data, value)
    return nil unless value_populated_from_baseline?(value)

    baseline_value = baseline_data
    
    value[:baselineKey].each do |key|
      baseline_value = baseline_value[key.to_sym]
      if baseline_value.class == Array
        baseline_value = baseline_value.first
      end
    end

    baseline_value
  end
end
