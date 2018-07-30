class LocalAuthority::Domain::ReturnTemplate
  attr_reader :layout

  def initialize(layout:)
    @layout = layout
  end
end
