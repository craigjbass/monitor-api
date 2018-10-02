class HomesEngland::UseCase::GetProjectUsers
  def initialize(user_gateway:)
    @user_gateway = user_gateway
  end

  def execute(project_id:)
    { users: @user_gateway.get_users(project_id: project_id).map(&:email) }
  end
end
