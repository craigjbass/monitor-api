class LocalAuthority::UseCase::GetReturns
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(project_id:)
    @return_gateway.get_returns(project_id: project_id).map do |r|
      {
        id: r.id,
        project_id: r.project_id,
        data: r.data
      }
    end
  end
end
