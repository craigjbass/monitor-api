# frozen_string_literal: true

class LocalAuthority::UseCase::GetReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(id:)
    gateway_return = @return_gateway.get_return(id: id)
    if gateway_return.nil?
      {}
    else
      { project_id: gateway_return.project_id, data: gateway_return.data }
    end
  end
end
