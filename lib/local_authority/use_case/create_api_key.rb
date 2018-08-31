class LocalAuthority::UseCase::CreateApiKey
  def execute(project_id:)
    api_key = JWT.encode({project_id: project_id}, ENV['HMAC_SECRET'], 'HS512')
    
    { api_key: api_key }
  end
end
