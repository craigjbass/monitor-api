class LocalAuthority::UseCase::CreateApiKey
  def initialize(api_key_gateway:)
    @api_key_gateway = api_key_gateway
  end

  def execute
    api_key = SecureRandom.uuid
    @api_key_gateway.save(api_key: api_key)
    { api_key: api_key}
  end
end
