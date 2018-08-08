class LocalAuthority::UseCase::GetReturns
  def initialize(return_gateway:, return_update_gateway:)
    @return_gateway = return_gateway
    @return_update_gateway = return_update_gateway
  end

  def execute(project_id:)
    returns = @return_gateway.get_returns(project_id: project_id)

    {
      returns: returns.map do |r|
        {
          id: r.id,
          project_id: r.project_id,
          status: r.status,
          updates: @return_update_gateway.updates_for(return_id: r.id).map(&:data)
        }
      end
    }
  end
end
