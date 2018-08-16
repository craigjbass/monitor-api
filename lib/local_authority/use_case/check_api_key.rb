class LocalAuthority::UseCase::CheckApiKey
  def initialize(api_key_gateway:)
    @api_key_gateway = api_key_gateway
  end

  def execute(api_key:)
    { valid: !@api_key_gateway.find_by(api_key: api_key).nil? }
  end
end
