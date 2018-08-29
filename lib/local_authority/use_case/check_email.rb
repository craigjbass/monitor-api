# frozen_string_literal: true

class LocalAuthority::UseCase::CheckEmail
  def initialize(users_gateway:)
    @users_gateway = users_gateway
  end

  def execute(email_address:)
    user = @users_gateway.find_by(email_address)
    { valid: !user.nil? }
  end
end
