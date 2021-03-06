# frozen_string_literal: true

class LocalAuthority::UseCase::CheckEmail
  def initialize(users_gateway:)
    @users_gateway = users_gateway
  end

  def execute(email_address:, project_id:)
    user = @users_gateway.find_by(email: email_address.downcase)
    if user.nil?
      { valid: false }
    else
      { valid: user.projects.include?(project_id) }
    end
  end
end
