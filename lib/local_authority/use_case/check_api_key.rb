class LocalAuthority::UseCase::CheckApiKey
  def execute(api_key:,project_id:)
    begin
      api_key_project_id = payload(api_key)['project_id']

      { valid: project_id == api_key_project_id}
    rescue JWT::DecodeError
      { valid: false }
    end
  end

  private 

  def payload(api_key)
    JWT.decode(
      api_key,
      ENV['HMAC_SECRET'],
      true,
      algorithm: 'HS512'
    )[0]
  end
end
