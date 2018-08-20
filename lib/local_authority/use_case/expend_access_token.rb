# frozen_string_literal: true

class LocalAuthority::UseCase::ExpendAccessToken
  def initialize(access_token_gateway:, create_api_key:)
    @access_token_gateway = access_token_gateway
    @create_api_key = create_api_key
  end

  def execute(access_token:)
    exists = !@access_token_gateway.find_by(access_token: access_token).nil?
    if exists
      api_key = @create_api_key.execute[:api_key]
      @access_token_gateway.delete(access_token: access_token)
      { status: :success, api_key: api_key }
    else
      { status: :failure, api_key: '' }
    end
  end
end
