# frozen_string_literal: true

require 'securerandom'
class LocalAuthority::UseCase::CreateAndSaveGUID
  def initialize(guid_gateway:)
    @guid_gateway = guid_gateway
  end

  def execute
    guid = SecureRandom.uuid
    @guid_gateway.save(guid: guid)
    { guid: guid}
  end
end
