class LocalAuthority::UseCase::SoftUpdateReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(return_id:, return_data:)
    @return_gateway.soft_update(return_id: return_id, return_data: return_data, status: 'Draft')
  end
end
