# frozen_string_literal: true

class LocalAuthority::UseCase::GetReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(id:)
    found_return = @return_gateway.find_by(id: id)
    if found_return.nil?
      {}
    else
      {
        id: found_return.id,
        project_id: found_return.project_id,
        data: found_return.data,
        status: found_return.status
      }
    end
  end
end
