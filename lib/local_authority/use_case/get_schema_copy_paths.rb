#This needs to be setup to use the gateway
class LocalAuthority::UseCase::GetSchemaCopyPaths
  def execute(template_schema:)
    descend_object(template_schema)
  end

  private

  def descend_object(template_schema, current_path = [])
    paths = []
    template_schema[:properties].each do |property,value|
      p value
      node_path = current_path + [property]
      if value[:type] == 'object'
        paths += descend_object(value, node_path)
      elsif value[:type] == 'array'
        paths += descend_object(value[:items], node_path)
      end

      if !value[:baselineKey].nil?
        paths << { to: node_path, from: value[:baselineKey] }
      end
    end
    paths
  end
end
