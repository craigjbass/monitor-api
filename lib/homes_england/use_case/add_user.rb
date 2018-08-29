class HomesEngland::UseCase::AddUser
  def initialize(user_gateway:)
    @user_gateway = user_gateway
  end

  def execute(email:)
    @user_gateway.create(
      LocalAuthority::Domain::User.new.tap do |u|
        u.email = email
      end
    )
  end
end
