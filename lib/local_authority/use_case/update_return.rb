# frozen_string_literal: true

class LocalAuthority::UseCase::UpdateReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(return_id:, data:)
    project_return = LocalAuthority::Domain::Return.new.tap do |r|
      r.id = return_id
      r.data = data
    end

    @return_gateway.update(project_return)
  end
end
