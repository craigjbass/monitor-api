class HomesEngland::Domain::Project
  attr_accessor :type, :data, :status
  
  def initialize
    @status = 'Draft'
  end
end
