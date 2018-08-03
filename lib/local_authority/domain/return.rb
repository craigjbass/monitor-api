class LocalAuthority::Domain::Return
  attr_accessor :id, :project_id, :data, :status
  def initialize()
    @status = 'Draft'
  end
end
