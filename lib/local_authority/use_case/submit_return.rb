class LocalAuthority::UseCase::SubmitReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(return_id:)
    @return_gateway.submit(return_id: return_id)
  end
end
