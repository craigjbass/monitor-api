class LocalAuthority::UseCase::SubmitReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(return_id:)
    timestamp = Time.now.to_i
    @return_gateway.submit(return_id: return_id, timestamp: timestamp)
  end
end
