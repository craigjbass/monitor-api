class LocalAuthority::Domain::Return
  attr_accessor :id, :project_id, :type, :status, :updates
  def initialize
    @status = 'Draft'
  end
end
