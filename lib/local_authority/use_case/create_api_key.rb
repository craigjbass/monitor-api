require 'date'

class LocalAuthority::UseCase::CreateApiKey
  def execute(project_id:)
    exp = DateTime.now.strftime("%s").to_i + (60 * 4)
    api_key = JWT.encode({project_id: project_id, exp: exp}, ENV['HMAC_SECRET'], 'HS512')
    
    { api_key: api_key }
  end
end
