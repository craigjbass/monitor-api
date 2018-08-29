# frozen_string_literal: true

require 'securerandom'

class LocalAuthority::UseCase::CreateAccessToken
  def initialize(access_token_gateway:)
    @access_token_gateway = access_token_gateway
  end

  def execute(project_id:)
    access_token = LocalAuthority::Domain::AccessToken.new.tap do |token|
      token.uuid = SecureRandom.uuid
      token.project_id = project_id
    end
    @access_token_gateway.create(access_token)
    { access_token: access_token.uuid }
  end
end
