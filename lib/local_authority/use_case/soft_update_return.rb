class LocalAuthority::UseCase::SoftUpdateReturn
  def initialize(return_update_gateway:)
    @return_update_gateway = return_update_gateway
  end

  def execute(return_id:, return_data:)
    update = LocalAuthority::Domain::ReturnUpdate.new.tap do |u|
      u.return_id = return_id
      u.data = return_data
    end

    @return_update_gateway.create(update)
  end
end
