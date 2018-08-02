class LocalAuthority::UseCase::CreateReturn
  def initialize(return_gateway:)
    @return_gateway = return_gateway
  end

  def execute(project_id:, data:, status: 'Draft')
    return_object = LocalAuthority::Domain::Return.new.tap do |r|
      r.project_id = project_id
      r.data = data
      r.status = status
    end

    { id: @return_gateway.create(return_object) }
  end
end
