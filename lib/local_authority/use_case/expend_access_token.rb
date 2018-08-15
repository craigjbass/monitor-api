class LocalAuthority::UseCase::ExpendAccessToken
  def initialize(access_token_gateway:)
    @access_token_gateway = access_token_gateway
  end

  def execute(access_token:)
    exists = !@access_token_gateway.find_by(access_token: access_token).nil?
    if exists
      @access_token_gateway.delete(access_token: access_token)
      {status: :success}
    else
      {status: :failure}
    end
  end
end

