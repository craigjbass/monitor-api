# frozen_string_literal: true

class HomesEngland::UseCase::DeleteUser
  def initialize(user_gateway:)
    @user_gateway = user_gateway
  end

  def execute(email:)
    @user_gateway.delete_user(email.downcase)
  end
end
