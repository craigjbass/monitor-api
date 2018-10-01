require 'json_schema'
class LocalAuthority::Domain::ReturnTemplate
  attr_accessor :layout, :schema

  def invalid_paths(the_return)
    schema = JsonSchema.parse!(JSON.parse(@schema.to_json))

    begin
      schema.validate!(JSON.parse(the_return.to_json))
    rescue JsonSchema::AggregateError => e
      paths = e.errors.select { |error| error.type == :required_failed || error.type == :one_of_failed }.map do |error|

        if error.type == :required_failed
          path = error.path[1..-1] + error.data

          path.map do |node|
            if node.class == String
              node.to_sym
            else
              node
            end
          end
        else
          error.path[1..-1].map do |node|
            if node.class == String
              node.to_sym
            else
              node
            end
          end
        end
      end
    end

    paths || []
  end
end
