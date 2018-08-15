# frozen_string_literal: true

require 'securerandom'
class LocalAuthority::UseCase::CreateAccessToken

  def initialize(access_token_gateway:)
    @access_token_gateway = access_token_gateway
  end

  def execute
    access_token = SecureRandom.uuid
    @access_token_gateway.save(access_token: access_token)
    { access_token: access_token}
  end
end
