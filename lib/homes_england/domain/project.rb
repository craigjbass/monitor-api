class HomesEngland::Domain::Project
  attr_accessor :id, :name, :type, :data, :status, :timestamp

  def initialize
    @status = 'Draft'
  end
end
