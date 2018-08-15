class LocalAuthority::UseCase::ExpendGUID
  def initialize(guid_gateway:)
    @guid_gateway = guid_gateway
  end

  def execute(guid:)
    exists = !@guid_gateway.find_by(guid: guid).nil?
    if exists
      @guid_gateway.delete(guid: guid)
      {status: :success}
    else
      {status: :failure}
    end
  end
end

