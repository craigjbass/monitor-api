class LocalAuthority::Domain::Return
  attr_accessor :id, :project_id, :type, :status, :updates, :timestamp
  def initialize
    @status = 'Draft'
  end
end
