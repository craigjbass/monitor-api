
class LocalAuthority::UseCase::GetSchemaCopyPaths
  def initialize(template_gateway:)
    @template_gateway = template_gateway
  end

  def execute(type:)
    { paths: descend_object(@template_gateway.find_by(type: type).schema) }
  end

  private

  def descend_object(template_schema, current_path = [])
    paths = []
    template_schema[:properties].each do |property, value|
      node_path = current_path + [property]
      if value[:type] == 'object'
        paths += descend_object(value, node_path)
      elsif value[:type] == 'array'
        paths += descend_object(value[:items], node_path)
      end

      unless value[:sourceKey].nil?
        paths << { to: node_path, from: value[:sourceKey] }
      end
    end

    template_schema[:dependencies]&.each do |property, value|
      value[:oneOf].each do |item|
        p item
        paths += descend_object(item, current_path)
      end
    end
    paths
  end
end
