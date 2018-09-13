class LocalAuthority::Domain::ReturnTemplate
  attr_accessor :layout, :schema

  def validate(return_data)
    JSON::Validator.fully_validate(
      schema.to_json,
      return_data
    )
  end
end
