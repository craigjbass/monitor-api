class HomesEngland::Domain::Template
  attr_reader :layout

  def initialize (layout:)
    @layout = layout
  end
end
