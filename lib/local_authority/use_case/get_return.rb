# frozen_string_literal: true

class LocalAuthority::UseCase::GetReturn
  def initialize(return_gateway:,return_update_gateway:)
    @return_gateway = return_gateway
    @return_update_gateway = return_update_gateway
  end

  def execute(id:)
    found_return = @return_gateway.find_by(id: id)
    updates = @return_update_gateway.updates_for(return_id: id)

    if found_return.nil?
      {}
    else
      {
        id: found_return.id,
        project_id: found_return.project_id,
        status: found_return.status,
        updates: updates.map(&:data)
      }
    end
  end
end
