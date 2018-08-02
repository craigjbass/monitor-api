# frozen_string_literal: true

class LocalAuthority::UseCase::UpdateReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(return_id:, data:)
    @return_gateway.update(return_id: return_id,data: data)
  end
end
