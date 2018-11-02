class HomesEngland::Domain::Project
  attr_accessor :name, :type, :data, :status, :timestamp

  def initialize
    @status = 'Draft'
  end
end
