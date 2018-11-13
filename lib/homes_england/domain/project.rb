class HomesEngland::Domain::Project
  attr_accessor :name, :type, :data, :status

  def initialize
    @status = 'Draft'
  end
end
