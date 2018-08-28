class HomesEngland::UseCase::AddUser
  def initialize(user_gateway:)
    @user_gateway = user_gateway
  end

  def execute(email:)
    @user_gateway.create(email)
  end
end
