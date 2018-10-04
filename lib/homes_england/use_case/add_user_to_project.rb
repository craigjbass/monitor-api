class HomesEngland::UseCase::AddUserToProject
  def initialize(user_gateway:)
    @user_gateway = user_gateway
  end

  def execute(email:, project_id:)
    user = @user_gateway.find_by(email: email)
    if user.nil?
      user = LocalAuthority::Domain::User.new.tap do |u|
        u.email = email.downcase
        u.projects = [project_id]
      end
      @user_gateway.create(user)
    else
      user.projects << project_id
      @user_gateway.update(user)
    end
  end
end
