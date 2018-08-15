# frozen_string_literal: true

require 'securerandom'
class LocalAuthority::UseCase::CreateGUID
  def execute
    { guid: SecureRandom.uuid }
  end
end
